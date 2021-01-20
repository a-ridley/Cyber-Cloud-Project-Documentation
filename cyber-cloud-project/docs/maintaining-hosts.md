---
id: maintaining-hosts
title: Maintenance For Hosts
---

## Deleting a host manually:
1. you might need to do this because a host exploded and you are rebuilding it, because it's the same host we need to remove any old provider ip's that point to the old host.
### Basic Guide w/ Curl:
1.  to find out how to replace &ltplacement-endpoint-address&gt
```
openstack catalog list
```
2. to get token: 
```
openstack token issue -f value -c id
```
```
curl -i -X GET <placement-endpoint-address>/resource_providers?name=<target-compute-host-name> -H 'content-type: application/json' -H 'X-Auth-Token: <token>'
```
curl -i -X GET http://controller:8778/resource_providers -H 'content-type: application/json' -H 'X-Auth-Token: &lttoken&gt
```
curl -i -X DELETE http://controller:8778/resource_providers/<provider_token> -H \
'content-type: application/json' -H 'X-Auth-Token: <token>'
```
### Clearing information from the database.
select * from host_mappings;
delete from host_mappings where id=<whatever_id>

SELECT id, created_at, updated_at, hypervisor_hostname FROM compute_nodes;

DELETE FROM compute_node_stats WHERE id=<Whatever_id>

### Better guide:
#### Find glance url
```
openstack catalog list
PLACEMENT_ENDPOINT=http://controller:8778
```  
#### get a new token
```
TOKEN=$(openstack token issue -f value -c id)
```
#### list resource providers
```
curl ${PLACEMENT_ENDPOINT}/resource_providers -H "x-auth-token: $TOKEN" | python -m json.tool
```
#### Delete resource provider
```
UUID=1e646c9d-279f-4482-9e9e-74865b4285f4
curl ${PLACEMENT_ENDPOINT}/resource_providers/$UUID -H "x-auth-token: $TOKEN" -X DELETE
```
#### If it fails to delete, List allocations
```
curl ${PLACEMENT_ENDPOINT}/resource_providers/${UUID}/allocations -H "x-auth-token: $TOKEN" | python -m json.tool
```
#### delete the allocations
```
CONSUMER=uuid-of-allocation-consumer-from-previous-API
curl ${PLACEMENT_ENDPOINT}/allocations/$CONSUMER -H "x-auth-token: $TOKEN" -X DELETE
```
