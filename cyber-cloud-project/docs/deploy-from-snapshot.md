---
id: deploy-from-snapshot
title: Deploy From Snapshot
---

## Deploying from a snapshot:
Deploying from a snapshot is simple with openstack.
## Creating the snapshot
A snapshot needs to be created on the dashboard from the instances page. On this page you can select an instance and use it's context menu on the far right to "Create Snapshot".
Note: If your snapshot relys on configurations such as cloud-init, or other script that run on boot, power-off your VM before creating a snapshot.

## Deploying a vm
After the snapshot is done building, (track progress on admin tab => images), you can deploy new vms by clicking the "create instance" button and then click on source on the left, and then click on select boot source, select instance snapshot. disable create new volume, select your snapshot and continue with the rest of the steps.