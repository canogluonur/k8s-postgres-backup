# k8s-postgres-backup
backup of postgres running on kubernetes.


 kubectl create secret generic aws-pg-secret  \\n  --from-literal=aws-access-key-id=<your key> \\n  --from-literal=aws-secret-access-key=<your secret access key> \\n  --from-literal=pg-pass=<your pg pass>
