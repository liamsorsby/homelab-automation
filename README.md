# Intro

Basic, but overly complex mess of a configuration for homelab.
The idea was to get something up and working with argocd so that we can start deploying things in a nicer way.

### Notes

* packer config doesn't quite work yet, currently used the below script to create a VM template for use with terraform until packer is fixed.

### Template created with the following script

Set test password & install packages
```bash
virt-customize -a /mnt/pve/SynologyNFS/template/iso/focal-server-cloudimg-amd64.img --root-password password:changeme --install qemu-guest-agent,ncat,net-tools,bash-completion
```

```bash
export VM_ID="9000"
qm create 9000 --memory 2048 --net0 virtio,bridge=vmbr0 --sockets 1 --cores 2 --vcpu 2  -hotplug network,disk,cpu,memory --agent 1 --name cloud-init-focal --ostype l26
qm importdisk $VM_ID /mnt/pve/SynologyNFS/template/iso/focal-server-cloudimg-amd64.img LVM
qm set $VM_ID --scsihw virtio-scsi-pci --virtio0 LVM:vm-$VM_ID-disk-0
qm set $VM_ID --ide2 LVM:cloudinit
qm set $VM_ID --boot c --bootdisk virtio0
qm set $VM_ID --serial0 socket
qm template $VM_ID
```

# Notes
 * had to change kube-proxy to ipvs mode manually by adding the following to the daemon-set container command: ```- --proxy-mode=ipvs```