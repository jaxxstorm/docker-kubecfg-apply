#/bin/bash

directory="$1"
action="$2"

# check if directory exists
if [ -z "$directory" ]
then
  echo "Usage: $0 {directory}"
  exit 1
fi

# loop through components
for compdir in $directory/*/
do
  echo "Processing component $compdir"
  # skip if no manifests exists
  if [ ! -d "$compdir/manifest" ]
  then
    echo "No manifests for $compdir - skipping"
    break
  fi

  # get the namespace
  namespace="$(cat $compdir/metadata/namespace_default)"

  # skip if no namespace to be safe
  if [ -z "$namespace" ]
  then
    echo "No namespace defined for ${compdir} at ${compdir}/metadata/namespace_default - skipping"
    break
  fi


  case "$action" in
    dry-run)
      /kubecfg update --dry-run --gc-tag "kubecfg_auto_apply_${compdir}" --namespace $namespace $compdir/manifest/*.yaml
      ;;
    update)
      /kubecfg update --gc-tag "kubecfg_auto_apply_${compdir}" --namespace $namespace $compdir/manifest/*.yaml
      ;;
    validate)
      /kubecfg validate --namespace $namespace $compdir/manifest/*.yaml
      ;;
    *)
      echo "Unknown action"
      exit 1
  esac

done


