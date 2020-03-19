#!/bin/bash

TRIGGER_TYPES="command"
TRIGGER_PATHS="sync edit open undo copy"
TRIGGER_PARAMS="%user%"

{
for trigger_type in $TRIGGER_TYPES; do
  for trigger_path in $TRIGGER_PATHS; do
    for prefix in pre-user post-user; do
      trigger_name=${trigger_type/-/_}_${trigger_path}_${prefix/-/_}
        mkdir -p ${trigger_type}
        echo "	test_${trigger_name} ${trigger_type} ${prefix}-${trigger_path} \"/opt/perforce/triggers/${trigger_type}/${trigger_name}.sh ${TRIGGER_PARAMS}\""
      {
        echo "#!/bin/bash"
        echo "echo \$* >> \"/opt/perforce/triggers/logs/${trigger_name}.log\""
      } > ${trigger_type}/${trigger_name}.sh
    done
  done
done
} > p4triggers_command.txt
