
# Diagnosis of Bug
Identified in the /var/log/nova/nova-api.log
```
ERROR nova.api.metadata.handler DBError: (pymysql.err.InternalError) (23, u'Out of resources when opening file \'/var/tmp/#sql_aba_0.MAD\' (Errcode: 24 "Too many open files")') [SQL: u'SELECT anon_1.instances_created_at AS anon_1_instances_created_at,
```

# Solution
## Increase DB Open File Limits
1. Create resources
```
mkdir -p /etc/systemd/system/mariadb.service.d/
vi /etc/systemd/system/mariadb.service.d/limits.conf
```

2. Add to limits.conf
```
[Service]
LimitNOFILE=10000
```

3. restart mariadb
```
systemctl daemon-reload
systemctl restart mariadb
./startup.sh
```

4. View changes
```
SHOW GLOBAL VARIABLES LIKE 'open_files_limit';
```
