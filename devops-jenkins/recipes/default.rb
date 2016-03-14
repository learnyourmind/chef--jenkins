#
# Cookbook Name:: devops-jenkins
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
#
include_recipe 'build-essential'

include_recipe 'chef-workstation::chefdk'

include_recipe 'devops-jenkins::mountpoint'

include_recipe 'jenkins::master'

# Overides the Jenkins cookbook to set mode back to 0750
r = resources(directory: node['jenkins']['master']['home'])
r.mode('750')

# Create a Jenkins user with specific attributes
jenkins_user 'grumpy' do
  full_name 'Grumpy Dwarf'
  email 'grumpy@example.com'
  password	'jenkins'
end

install_method = node['jenkins']['master']['install_method']
restart_resource = case install_method
                   when 'package' then 'service[jenkins]'
                   when 'war' then 'runit_service[jenkins]'
                   else fail "Install method '#{install_method}' is not supported"
                   end

template '/var/lib/jenkins/config.xml' do
  source 'config.erb'
  owner 'jenkins'
  group 'jenkins'
  mode '644'
  notifies :restart, restart_resource, :delayed
end

##
# Install plugins
jenkins_plugin 'git' do
  notifies :restart, restart_resource, :delayed
end

jenkins_plugin 'rake' do
  notifies :restart, restart_resource, :delayed
end

include_recipe 'devops-jenkins::jobs'
