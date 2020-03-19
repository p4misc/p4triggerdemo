#!/bin/bash
set -e

export P4ROOT=/opt/perforce/p4root
export P4LOG=log
export P4PORT=1666
export P4USER=bruno

for trigger in `ls /opt/perforce/triggers/p4triggers_*.txt`; do
  cat $trigger >> /opt/perforce/triggers/p4triggers.txt
done

/opt/perforce/sbin/p4d -r $P4ROOT -jr checkpoint
/opt/perforce/sbin/p4d -r $P4ROOT -xu
/opt/perforce/sbin/p4d -r $P4ROOT -xi
/opt/perforce/sbin/p4d -r $P4ROOT -p $P4PORT -L $P4LOG -d
/opt/perforce/bin/p4 triggers -i < /opt/perforce/triggers/p4triggers.txt
exec tail -f /opt/perforce/p4root/log
