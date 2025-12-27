FROM alpine:latest

# Packages required for monitoring script
RUN apk add --no-cache bash coreutils curl jq
# bash: monitor.sh is written using bash
# coreutils: sub-second resolution from date. required for sending ping time to monitor
# curl: sending push to monitor
# jq: parsing result from monitor in case the push fails

COPY ./app/monitor.sh /app/monitor.sh

RUN chmod +x /app/monitor.sh

# ENTRYPOINT ["/bin/bash", "-c", "while true; do /mnt/monitor.sh; sleep 180; done"]
CMD ["sleep", "infinity"]
# Entrypoint will be ran as a healthcheck
#   This allows it to be ran on a regular interval, as well as exiting the container on errors
