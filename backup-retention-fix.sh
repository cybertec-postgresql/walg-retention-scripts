#!/bin/bash

#
#   backup-retention-fix.sh
#
#   script copies fixed version of postgres_backup.sh
#   ref bug https://github.com/zalando/spilo/issues/1015
#
#   to execute:
#       KUBECONFIG=... ./backup-retention-fix.sh  | tee ./backup-retention-fix.log
#

# Fetch the list of pods with spilo-role=master across all namespaces
pod_list=$(kubectl get pods --all-namespaces -l application=spilo -o jsonpath='{range .items[*]}{.metadata.name}{" "}{.metadata.namespace}{"\n"}{end}')

# Check if the pod_list is not empty
if [ -z "$pod_list" ]; then
    echo "No pods with role=master found."
    exit 0
fi

# Process each pod name and namespace pair
echo "$pod_list" | while read -r pod_name namespace; do
    echo -n "Processing pod: $pod_name in namespace: $namespace"

    #if [ "$namespace" != "scalefield-23-125" ]; then
    #    echo " skip."
    #    continue  # Skip to the next iteration if namespace is not "test"
    #fi    
    
    kubectl cp postgres_backup.sh \
      "$pod_name:/scripts/postgres_backup.sh" \
      -c postgres --no-preserve \
      -n "$namespace"

    if [ $? -eq 0 ]; then
        echo " done"
    else
        echo " error"
    fi      

done
