#!/bin/bash

TRIGGER_TYPES="change-submit change-content change-commit change-failed push-submit push-content push-commit shelve-submit shelve-commit shelve-delete"
TRIGGER_PATHS="//..."
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
} > p4triggers_submit.txt
