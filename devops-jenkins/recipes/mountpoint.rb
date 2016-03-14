#
# Cookbook Name:: devops-jenkins
# Recipe:: mountpoint
#
# Copyright 2015, Barclays Bank
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

#
## Setup the file system mount points used during Jenkins install.
#

# Include lvm to get access to lvm_volume_group and lvm_logical_volume resources
include_recipe 'lvm::default'

# Configure mount attributes
node.default['devops-jenkins']['mounts']['data_dir']['path']    = node['devops-jenkins']['data_dir']
node.default['devops-jenkins']['mounts']['data_dir']['user']    = node['devops-jenkins']['install']['user']
node.default['devops-jenkins']['mounts']['data_dir']['group']   = node['devops-jenkins']['install']['group']

node['devops-jenkins']['volume_groups'].each do |key, value|
  devices = value['devices']

  lvm_volume_group key do
    physical_volumes devices
  end
end

%w(data_dir).each do |key|
  value = node['devops-jenkins']['mounts'][key]

  mount_point = value['path']
  fstype      = value['fstype']
  user        = value['user']
  group       = value['group']
  mode        = value['mode']
  lv_group    = value['lv_group']
  size        = value['size']

  lvm_logical_volume key do
    group lv_group
    size size
    filesystem fstype
    mount_point mount_point
  end

  directory mount_point do
    owner user
    group group
    mode mode
  end
end
