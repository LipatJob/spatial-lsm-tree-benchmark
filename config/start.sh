#!/bin/bash

apt-get update
apt-get install -y procps

CONFIGDIR="/opt/asterixdb/config"
BINDIR="/opt/asterixdb/bin"
LOGSDIR="/opt/asterixdb/logs"

mkdir -p "$LOGSDIR"

touch "$LOGSDIR/nc-asterix_nc1.log"

echo "Starting AsterixDB cluster with the following configuration:"
echo " --- cc.conf ---"
cat "$CONFIGDIR/cc.conf" | grep -v '^#' | grep -v '^$'
echo ""
echo " --- nc.conf ---"
cat "$CONFIGDIR/nc.conf" | grep -v '^#' | grep -v '^$'
echo ""


UNIX_TIMESTAMP=$(date +%s)

echo 
echo "INFO: Starting AsterixDB cluster..."
"$BINDIR/asterixncservice" -logdir - -config-file "$CONFIGDIR/nc.conf" >> "$LOGSDIR/nc.log" &
"$BINDIR/asterixcc" -config-file "$CONFIGDIR/cc.conf" >> "$LOGSDIR/cc.log" &
"$BINDIR/asterixhelper" wait_for_cluster -timeout 90

iotop -Pabotqk > $LOGSDIR/network/iotop_$UNIX_TIMESTAMP.log &
echo "I/O metrics are being written to $LOGSDIR/network/iotop.log"

NCPID=$(ps aux | grep "[a]sterixcc" | awk '{print $2}')
mkdir "$LOGSDIR/disk"
while true; do
  echo "---"
  echo "timestamp: $(date +%s)"
  cat "/proc/$NCPID/io"
  sleep 1
done >> "$LOGSDIR/disk/disk_cc_$UNIX_TIMESTAMP.log" &
echo "INFO: Disk logs are being written to $LOGSDIR/disk/disk_cc_$UNIX_TIMESTAMP.log"

echo "INFO: AsterixDB cluster started. Logs are being written to $LOGSDIR" &
tail -f "$LOGSDIR/nc.log" "$LOGSDIR/nc-asterix_nc1.log";