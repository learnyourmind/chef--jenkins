#
## Cookbook Name:: devops-jenkins
## Spec:: jobs
##
## Copyright (c) 2016 The Authors, All Rights Reserved.
#
require 'spec_helper'
require 'tmpdir'

describe 'devops-jenkins::jobs' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(file_cache_path: RSpec.configuration.devops_jenkins[:temp_path])
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'Correctly creates chef installed' do
      expect(chef_run).to create_jenkins_job('Chef Installed')

      # TODO: verify config of chef installed matches expectations
    end

    it 'Correctly creates  file chef_installed_xml' do
      chef_installed_xml = File.join(Chef::Config[:file_cache_path],
                                     'chef-installed-config.xml')
      expect(chef_run).to create_template(chef_installed_xml)
    end
  end

  context 'When Some jobs present' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(file_cache_path: RSpec.configuration.devops_jenkins[:temp_path]) do |node|
        node.set['devops-jenkins']['job']['bcuk-ad']['repo_url'] = 'http://172.21.68.8:8080/scm/cd/bcuk-ad.git'
        node.set['devops-jenkins']['job']['bcuk-ad']['type'] = 'cookbook'
        node.set['devops-jenkins']['job']['bcuk-apachemq']['repo_url'] = 'http://172.21.68.8:8080/scm/cd/bcuk-apachemq.git'
        node.set['devops-jenkins']['job']['bcuk-apachemq']['type'] = 'cookbook'
      end
      runner.converge(described_recipe)
    end

    it 'Correctly creates cookbook jobs' do
      chef_run.node['devops-jenkins']['job'].each do |job_name, _details|
        expect(chef_run).to create_jenkins_job(job_name)
      end
    end

    it ' Correctly Creates file job_xml_path' do
      chef_run.node['devops-jenkins']['job'].each do |job_name, details|
        file_name = "#{job_name}-config.xml".gsub(/\s/, '_')
        job_xml_path = File.join(Chef::Config[:file_cache_path], file_name)
        expect(chef_run).to create_template(job_xml_path).with(
          variables: { repo_url: details['repo_url'] }
        )
      end
    end
  end
end
