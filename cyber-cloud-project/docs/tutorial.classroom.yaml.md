---
id: tutorial.classroom.yaml
title: tutorial.classroom.yaml
---

```
# The version number is used for backwards compatibility.
Version: 1.1
# The domain and project set the scope of this script. 
Domain: 
  Name: <String>
Project: 
  Name: <String>
      
# Each network is specified as an item in an array.
Network:
  # The name of the network.
  - Name: <String>
  # The name of another network to use as our provider network.
    Provider: <External Network Name> 
    Type: <External|Internal>
    # CIDR Format for the subnet to attach to the network
    Subnet: <CIDR>

# Each line is a csv of a student.
Students:
  - <Last Name>,<First Name>,<Username>
  - Campos,Miguel,mcampos
# Each line is a csv of a VM.
Machines:
  - <Name>,<Instances>,<Image>,<Flavor>,<Network>
  - Test,1,CirrOS,Small,External_Network

  ```