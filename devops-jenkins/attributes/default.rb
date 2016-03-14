# Additional OS packages needed
default['devops-base']['managed-packages']['xz-devel'] = 'upgrade'
default['devops-base']['managed-packages']['zlib-devel'] = 'upgrade'

## General Oracle settings.
default['devops-jenkins']['data_dir'] = '/var/lib/jenkins'
default['devops-jenkins']['install']['group']  = 'root'
default['devops-jenkins']['install']['user']   = 'root'
default['devops-jenkins']['install']['mode']   = '0750'

## Configuration of logical volume groups
default['devops-jenkins']['volume_groups']['vg_jen']['devices'] = ['/dev/vdb']

## Configuration for FS mount points related to Jenkins
default['devops-jenkins']['mounts']['data_dir']['lv_group']   = 'vg_jen'
default['devops-jenkins']['mounts']['data_dir']['fstype']     = 'ext4'
default['devops-jenkins']['mounts']['data_dir']['size']       = '100%FREE'
default['devops-jenkins']['mounts']['data_dir']['mode']       = '0750'
