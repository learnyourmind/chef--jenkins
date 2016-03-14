devops-jenkins Cookbook
==========================
This cookbook is used to create a jenkins server.

## Requirements

## Pre-Requisites

## Recipes

#### filesystem_mounts

    Uses LVM to attach and configure additional storage volumes as filesystems. Filesystems
    created in this recipe are:
      * /var/lib/jenkins               (Data directory for jenkins files)

## Attributes

### devops-jenkins::mountpoints

#### Volume Group
This cookbook uses LVM to configure a single volume group.

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['jenkins']['volume_groups']['vg_jen']['devices']</tt></td>
    <td>Array of Strings</td>
    <td>Array of block devices to create the vg_jen volume group on</td>
    <td><tt>'/dev/vdb'</tt></td>
  </tr>
</table>

#### Mount Points
The new mount point is configured as default via attributes as detailed in the following table:

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['jenkins']['mounts']['data_dir']['lv_group']</tt></td>
    <td>String</td>
    <td>Name of the volume group to be located on (see Volume Groups)</td>
    <td><tt>vg_jen</tt></td>
  </tr>
  <tr>
    <td><tt>['jenkins']['mounts']['data_dir']['fstype']</tt></td>
    <td>String</td>
    <td>A filesystem type supported by LVM</td>
    <td><tt>ext4</tt></td>
  </tr>
  <tr>
    <td><tt>['jenkins']['mounts']['data_dir']['size']</tt></td>
    <td>String</td>
    <td>Size (see below)</td>
    <td><tt>Currently set to 100% of volume, but can vary (see below)</tt></td>
  </tr>
  <tr>
    <td><tt>['jenkins']['mounts']['data_dir']['mode']</tt></td>
    <td>String</td>
    <td>Mode mode of the mount point</td>
    <td><tt>0750</tt></td>
  </tr>
</table>

#### Size
The mount point size can be defined as one of the following:

    * An integer followed immediately by one of the following: k,K,m,M,g,G,t,T,p,P,e,E
    * An integer 0-100 followed immediately by one of the following:
        * '%FREE'   - % of space free on the Volume Group (see order of allocation)
        * '%VG'     - % of the volume group on which the volume is being created


#### Order of allocation
Since %FREE depends upon what has already been allocated, the order of allocation is important going forward.
Only one mountpoint (data_dir) is allocated currently  and therefore has all of the volume space allocated, but should new mounts be required order will need to be defined carefully or specfic sizes allocated.

#### Default sizes
<table>
  <tr>
    <th>Mount Point</th>
    <th>Default Size</th>
  </tr>
  <tr>
    <td><tt>data_dir</tt></td>
    <td><tt>100%FREE</tt></td>
  </tr>
</table>

Sample output of df with the default settings, given a vg_jen having an arbitrary size of 32G:

    df -h
    Filesystem                   Size  Used Avail Use% Mounted on
    /dev/mapper/rhel-root         18G  3.7G   14G  21% /
    devtmpfs                     911M     0  911M   0% /dev
    tmpfs                        921M     0  921M   0% /dev/shm
    tmpfs                        921M  8.4M  912M   1% /run
    tmpfs                        921M     0  921M   0% /sys/fs/cgroup
    /dev/vda1                    497M  256M  242M  52% /boot
    /dev/mapper/vg_jen-data_dir   32G  515M   30G   2% /var/lib/jenkins
