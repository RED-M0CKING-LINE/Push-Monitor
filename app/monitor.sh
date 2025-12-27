#!/bin/bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# DEFINE MONITOR CHECK COMMAND HERE
#CMD="$CMD"

# DEFINE MONITOR PUSH URL HERE (Exclude any GET parameters)
#PUSH_URL="$PUSH_URL"

# Run command
START_NS=$(/bin/date +%s%N)
OUTPUT="$(/bin/bash -lc "$CMD" 2>&1)"
RC=$?
END_NS=$(/bin/date +%s%N)

# Process output
PING_MS=$(( (END_NS - START_NS) / 1000000 ))

[ "${DEBUG:-false}" = "true" ] && echo "${END_NS}ns - ${START_NS}ns = ${PING_MS}ms"

if [ $RC -eq 0 ]; then
  STATUS="up"
  MSG="${OUTPUT%%$'\n'*}"
elif [ "$RC" -eq 126 ] || [ "$RC" -eq 127 ]; then  # Handle command not found or command not executable
  echo "$OUTPUT" 
  exit $RC
else
  STATUS="down"
  MSG="ERROR ($RC): ${OUTPUT%%$'\n'*}"
  echo "$STATUS $RC $PING_MS $OUTPUT"
fi

[ "${DEBUG:-false}" = "true" ] && echo "$STATUS $RC $PING_MS $OUTPUT"

# Send push
CURL_RESPONSE="$(
  curl --get --no-progress-meter \
    --data-urlencode "status=$STATUS" \
    --data-urlencode "rc=$RC" \
    --data-urlencode "ping=${PING_MS}ms" \
    "$PUSH_URL"
)"

[ "${DEBUG:-false}" = "true" ] && echo "$CURL_RESPONSE"

# Evaluate push status
OK_VALUE="$(echo "$CURL_RESPONSE" | jq -r '.ok')"

if [ "$OK_VALUE" != "true" ]; then
  echo "Push failed or monitor not active (ok=$OK_VALUE)" >&2
  exit 1
fi

exit 0
