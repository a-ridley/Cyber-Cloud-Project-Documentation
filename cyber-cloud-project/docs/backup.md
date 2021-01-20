---
id: backup
title: Create Backup Job
---

**Purpose:** Install Veeam agent on selected endpoint to Veeam console

**Scope:** Add an endpoint to Veeam, place it in a protection plan and create and test a back up


**Target:** Endpoint the backup is being made from or restored to

**Prerequisites:** System must be supported by Veeam, job must be checked for requirements not technically supported.

## 1.0 First Preparatory Activity-Plan

**The following information is needed:**

- System OS and machine tyoe to be protected (ex. CentOS 7 or Windows, Host or VM)
- System credentials for the endpoint to be protected
- Repository Identified and required space confirmed
- Backup Type, scope, and frequency
- Identification of files or folders or Directores if relevant

## 2.0 Second Activiy- Do

### Create a backup job on the Veeam Dashboard on the Veeam Server.

Our example is a Linux OS machine host

![img](../static/img/backup-imgs/example-linux-os-host.jpg)

This job is being created as a server based (Veeam Server) backup

![img](../static/img/backup-imgs/new-agent-backup-job.png)


:::note

**Example backup job is for compute5**

:::

![img](../static/img/backup-imgs/example-backup-compute5.png)

The backup job **Name** should either follow a naming convention or be unique and identifiable. A single endpoing may have multiple jobs.

### Computers Section

![img](../static/img/backup-imgs/example-backup-computers-section.png)

Click **Individual Computer**  

![img](../static/img/backup-imgs/example-backup-individual-computer.png)


:::tip

** IP used instead of Hostname (compute5 in example). Use IP if hostname does not resolve.**

:::

![img](../static/img/backup-imgs/example-backup-add-computer.png)

**Note credentials chosen above**

![img](../static/img/backup-imgs/example-backup-protected-computers.png)


### Backup Mode Section

Select 'Entire Computer'

![img](../static/img/backup-imgs/example-backup-entire-complete.png)

### Storage Section

In this example there is only a single restore point selected.

![img](../static/img/backup-imgs/example-backup-single-restore-point.png)

### Guest Processing Section

No option is selected here.

![img](../static/img/backup-imgs/example-backup-guest-processing.png)

### Schedule Section

No periodicity is selected.

![img](../static/img/backup-imgs/example-backup-schedule-section.png)

### Summary Section

![img](../static/img/backup-imgs/example-backup-summary.png)

Creation of job to this point with all needed information should take approximately 10 minutes.

## 3.0 Third Activiy- Check

A job can be checked following its first run with status and feedback information. This data can and should be referenced regulary to ensure backups are occurring successfully and appropriately.

![img](../static/img/backup-imgs/backup-example-third-activity-check.png)


## 4.0 Verify Backup File

Once a backup job has been configured and been successful in creating a backup verification of the file can be accomplished by going to the location of the backup file. This hould be reachable by selecting the correct repository under 'HOME>Backups'

![img](../static/img/backup-imgs/backup-example-home-backups.png)

![img](../static/img/backup-imgs/example-backup-backup-properties.png)

Full backup for test example compute5 is 3.11 GB.

For more information please contact aaronsmith@sandiego.edu
















