1. must be on a machine that can ssh 

ansible-playbook -i inventory set-hostname --ask-pass --ask-become-pass -u root


pseudocode: 
1. A client boots up.
2. A script runs and checks its hostname. It makes a curl request to the controller for using it's IP as a parameter and it's OS type/name.
2.1 The controller will authenticate, find the server's hostname, and respond with it.
3. The script will set the hostname and self destruct.

rm server.js
vi server.js
docker build -t metadata:latest -f Dockerfile . 
sudo docker run -it -p 8069:8069 --rm --name metadata-server metadata

export OS_AUTH_URL=http://controller:5000/v3/
export OS_COMPUTE_API=http://controller:8774/v2.1
export OS_USERNAME=admin
export OS_PASSWORD=<OS_PASSWORD>
export OS_USER_DOMAIN_NAME=default
export OS_PROJECT_DOMAIN_NAME=default
export OS_PROJECT_NAME=admin

curl -v -s -X POST $OS_AUTH_URL/auth/tokens?nocatalog   -H "Content-Type: application/json"   -d '{ "auth": { "identity": { "methods": ["password"],"password": {"user": {"domain": {"name": "'"$OS_USER_DOMAIN_NAME"'"},"name": "'"$OS_USERNAME"'", "password": "'"$OS_PASSWORD"'"} } }, "scope": { "project": { "domain": { "name": "'"$OS_PROJECT_DOMAIN_NAME"'" }, "name":  "'"$OS_PROJECT_NAME"'" } } }}' \
| python -m json.tool

export OS_TOKEN=<TOKEN FROM ABOVE>

curl -s -H "X-Auth-Token: $OS_TOKEN" $OS_COMPUTE_API/servers?all_tenants=true | python -m json.tool

curl 192.168.128.12:8069/hostname?ip=10.10.1.235
