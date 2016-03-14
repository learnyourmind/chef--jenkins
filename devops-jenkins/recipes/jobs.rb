#
# Cookbook Name:: devops-jenkins
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
#

chef_installed_xml = File.join(Chef::Config[:file_cache_path],
                               'chef-installed-config.xml')

template chef_installed_xml do
  source 'chef-installed-config.xml.erb'
end

jenkins_job 'Chef Installed' do
  config chef_installed_xml
end

# Install cookbooks jobs
jobs = node['devops-jenkins'] && node['devops-jenkins']['job'] || {}
cookbook_jobs = jobs.select { |_job_name, details| details['type'] == 'cookbook' }

cookbook_jobs.each do |job_name, details|
  file_name = "#{job_name}-config.xml".gsub(/\s/, '_')
  job_xml_path = File.join(Chef::Config[:file_cache_path], file_name)

  repo_url = details['repo_url']
  fail "'repo_url' for '#{job_name}' must not be nil" unless repo_url

  template job_xml_path do
    source 'test-cookbook-config.xml.erb'
    variables(
      repo_url: repo_url
    )
  end

  jenkins_job job_name do
    config job_xml_path
  end
end
