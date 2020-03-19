#!/bin/bash

TRIGGER_TYPES="fix-add fix-delete"
TRIGGER_PATHS="fix"
TRIGGER_PARAMS="%user%"

{
for trigger_type in $TRIGGER_TYPES; do
  for trigger_path in $TRIGGER_PATHS; do
    trigger_name=${trigger_type/-/_}
      mkdir -p ${trigger_type}
      echo "	test_${trigger_name} $trigger_type $trigger_path \"/opt/perforce/triggers/${trigger_type}/${trigger_name}.sh ${TRIGGER_PARAMS}\""
    {
      echo "#!/bin/bash"
      echo "echo \$* >> \"/opt/perforce/triggers/logs/${trigger_name}.log\""
    } > ${trigger_type}/${trigger_name}.sh
  done
done
} > p4triggers_fix.txt
