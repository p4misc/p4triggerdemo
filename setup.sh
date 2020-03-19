#!/bin/bash

BASH_PROF=/opt/perforce/.bash_profile
cat <<"EOF" >$BASH_PROF
export PATH=/opt/perforce/bin:/opt/perforce/sbin:$PATH
export P4CONFIG=.p4config
export P4P4PORT=1666
PS1='\u@\h:\w$ '
EOF
chown perforce:perforce $BASH_PROF
