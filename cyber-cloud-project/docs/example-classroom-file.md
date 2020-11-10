---
id: example-classroom-file
title: Example Classroom File
---

```
Version: 1.1
Project:
  Name: Test
Networks:
  - Name: Test
    Provider: Cloud-Provider
    External: True
    Subnet: 10.10.10.0/24
Students:
  - Test1,Test1,Test1
  - Test2,Test2,Test2
  - Test3,Test3,Test3
  - Test4,Test4,Test4
  - Test5,Test5,Test5
Machines:
  PerProject:
    - ProjectServer,2,CentOS 7,large,Test
  PerUser:
    - UserServer,2,CentOS 7,large,Test

```