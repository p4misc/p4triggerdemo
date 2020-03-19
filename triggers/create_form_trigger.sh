#!/bin/bash

TRIGGER_TYPES="form-save form-out form-in form-delete form-commit"
TRIGGER_PATHS="branch change client depot group job label protect server spec stream triggers typemap user"
TRIGGER_PARAMS="%user%"

{
for trigger_type in $TRIGGER_TYPES; do
  for trigger_path in $TRIGGER_PATHS; do
    trigger_name=${trigger_type/-/_}_${trigger_path}
      mkdir -p ${trigger_type}
      echo "	test_${trigger_name} $trigger_type $trigger_path \"/opt/perforce/triggers/${trigger_type}/${trigger_name}.sh ${TRIGGER_PARAMS}\""
    {
      echo "#!/bin/bash"
      echo "echo \$* >> \"/opt/perforce/triggers/logs/${trigger_name}.log\""
    } > ${trigger_type}/${trigger_name}.sh
  done
done
} > p4triggers_form.txt
