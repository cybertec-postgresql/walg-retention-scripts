# walg-retention-scripts
Fix for walg retention issue

Reference bug: https://github.com/zalando/spilo/issues/1015


deploy cronjob using kubectl
```
kubectl apply -f pg_backp_retention_fix.yaml
```
