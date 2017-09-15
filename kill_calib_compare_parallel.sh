PID=$1
TMPFILE="p32874tmp"
rm $TMPFILE 2> /dev/null

kill -9 ${PID} 2> $TMPFILE
rm $TMPFILE 2> /dev/null

RETVAL=""
while [ "${RETVAL}" == "" ]; do
  killall -TERM parallel 2> $TMPFILE
  RETVAL=$(< $TMPFILE)
  sleep 0.4
done
echo "done killing parallel"
rm $TMPFILE 2> /dev/null
RETVAL=""
while [ "${RETVAL}" == "" ]; do
  killall desktop_vio 2> $TMPFILE
  RETVAL=$(< $TMPFILE)
  sleep 0.4
done
echo Done killing vio
rm $TMPFILE 2> /dev/null
RETVAL=""
while [ "${RETVAL}" == "" ]; do
  killall desktop_com 2> $TMPFILE
  RETVAL=$(< $TMPFILE)
  sleep 0.4
done
echo "retval: $RETVAL"
echo DONE killing com
rm $TMPFILE 2> /dev/null
