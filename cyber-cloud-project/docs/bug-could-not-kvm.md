# Symptoms:
- unable to provision vms on this host.
- unable to migrate vms to this host.
- unable to access information about this hosts hypervisor.
- invalid detail when using openstack cli w/ host's hypervisor.
# Diagnosis:
- Error message: `could not find capabilities for domaintype=kvm` found when running command: `sudo tail /var/log/nova/nova-conductor.log -n 100 | grep -E -C 5 '(ERROR|error|Error)'`
- Detailed Controller Error Message:
```
 Error from last host: compute3 (node compute3.usdcyber.edu): [ Build of instance cff0dacc-024a-4bb0-9cb9-c6871053f7d0 was re-scheduled: invalid argument: could not find capabilities for domaintype=kvm]
```
- Detailed error on Compute hosts:
```
On Compute3:
QEMU: Checking if device /dev/kvm exists
FAIL (Check that the 'kvm-intel' or 'kvm-amd' modules are loaded & the BIOS has enabled virtualization)
```
- Run `virt-host-validate` to determine the status of kvm.

## Solution
1. Manual intervention is required, virtualization is activated thru the bios and the machine must be rebooted.
2. AFter you attempt to verify, if you are unable to see that the kvm device is installed: use `mknod /dev/kvm c 10 232` to manually create the device.

## Verification:
1. using `virt-host-validate` to verify that the KVM device was installed.