# !/bin/bash

set -e # Fail if errors occur
set -o pipefail

# Rerun after changes to OSM data (e. g. adding new rooms or changing existing ones)

# Get the directory of the script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Define output file path
OUTPUT_FILE="${SCRIPT_DIR}/../assets/overpass_osm/"


## SAMPLE DATA_QUERY='[out:json][timeout:25]; nwr["indoor"="room"]["ref"~""](52.174312,10.542111,52.183790,10.564728); out tags geom;'

QUERY_BEGINNING='[out:json][timeout:25]; nwr["indoor"="room"]["ref"~""]('
QUERY_END='); out tags geom;'

# Wolfenbüttel Campus:
BBOX_WFB='52.174312,10.542111,52.183790,10.564728'
# http://bboxfinder.com/#52.174312,10.542111,52.183790,10.564728

# Salzgitter Campus Calbrecht:
BBOX_SZG='52.081906,10.371480,52.092744,10.390105'
# http://bboxfinder.com/#52.081906,10.371480,52.092744,10.390105

# Campus Wolfsburg
BBOX_WOB='52.423550,10.774144,52.426504,10.788885'
# http://bboxfinder.com/#52.423550,10.774144,52.426504,10.788885

# Campus Suderburg: 
BBOX_SDB='52.896564,10.443470,52.898713,10.448105'
# http://bboxfinder.com/#52.896564,10.443470,52.898713,10.448105

echo "Fetching OSM data..."

# Ensure the assets directory exists
mkdir -p "$(dirname "$OUTPUT_FILE")"

# TODO: Für Wolfenbüttel, Suderburg, Wolfsburg, Salzgitter

# Wolfenbüttel:
echo "Fetching WFB..."
curl -X GET --data-urlencode "data=${QUERY_BEGINNING}${BBOX_WFB}${QUERY_END}" "https://overpass-api.de/api/interpreter" | \
  jq '.elements | map({id: .id, level: .tags.level, ref: .tags.ref}) | map({(.ref): {id: .id, level: .level}}) | add' > "$OUTPUT_FILE"WFB.json

# Suderburg:
echo "Fetching SDB..."
curl -X GET --data-urlencode "data=${QUERY_BEGINNING}${BBOX_SDB}${QUERY_END}" "https://overpass-api.de/api/interpreter" | \
  jq '.elements | map({id: .id, level: .tags.level, ref: .tags.ref}) | map({(.ref): {id: .id, level: .level}}) | add' > "$OUTPUT_FILE"SDB.json

# Salzgitter:
echo "Fetching SZG..."
curl -X GET --data-urlencode "data=${QUERY_BEGINNING}${BBOX_SZG}${QUERY_END}" "https://overpass-api.de/api/interpreter" | \
  jq '.elements | map({id: .id, level: .tags.level, ref: .tags.ref}) | map({(.ref): {id: .id, level: .level}}) | add' > "$OUTPUT_FILE"SZG.json

# Wolfsburg:
echo "Fetching WOB..."
curl -X GET --data-urlencode "data=${QUERY_BEGINNING}${BBOX_WOB}${QUERY_END}" "https://overpass-api.de/api/interpreter" | \
  jq '.elements | map({id: .id, level: .tags.level, ref: .tags.ref}) | map({(.ref): {id: .id, level: .level}}) | add' > "$OUTPUT_FILE"WOB.json

# Validate JSON
if ! jq empty "${OUTPUT_FILE}WFB.json" 2>/dev/null; then
  echo "[ERROR] WFB: Invalid JSON generated!"
  exit 1
else
  echo "✓ Successfully saved room data to ${OUTPUT_FILE}WFB.json"
fi

if ! jq empty "${OUTPUT_FILE}SDB.json" 2>/dev/null; then
  echo "[ERROR] SDB: Invalid JSON generated!"
  exit 1
else
  echo "✓ Successfully saved room data to ${OUTPUT_FILE}SDB.json"
fi

if ! jq empty "${OUTPUT_FILE}SZG.json" 2>/dev/null; then
  echo "[ERROR] SZG: Invalid JSON generated!"
  exit 1
else
  echo "✓ Successfully saved room data to ${OUTPUT_FILE}SZG.json"
fi

if ! jq empty "${OUTPUT_FILE}WOB.json" 2>/dev/null; then
  echo "[ERROR] WOB: Invalid JSON generated!"
  exit 1
else
  echo "✓ Successfully saved room data to ${OUTPUT_FILE}WOB.json"
fi
