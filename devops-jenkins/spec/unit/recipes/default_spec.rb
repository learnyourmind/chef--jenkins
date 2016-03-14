#
# Cookbook Name:: devops-jenkins
# Spec:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'
require 'tmpdir'

describe 'devops-jenkins::default' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(file_cache_path: RSpec.configuration.devops_jenkins[:temp_path])
      runner.converge(described_recipe)
    end

    it 'Correctly creates /var/lib/jenkins/config.xml' do
      expect(chef_run).to create_template('/var/lib/jenkins/config.xml').with(
        user: 'jenkins',
        group: 'jenkins',
        mode: '644'
      )
    end

    it 'creates a user with attributes' do
      expect(chef_run).to create_jenkins_user('grumpy').with(
        full_name: 'Grumpy Dwarf',
        email: 'grumpy@example.com',
        password: 'jenkins')
    end

    it 'Correctly Creates plugin git' do
      expect(chef_run).to install_jenkins_plugin('git')
    end

    it 'Correctly Creates plugin rake' do
      expect(chef_run).to install_jenkins_plugin('rake')
    end

    it 'should have a configure tmp path' do
      expect(RSpec.configuration.devops_jenkins).to_not be_nil
      expect(RSpec.configuration.devops_jenkins[:temp_path]).to_not be_nil
    end
    it 'includes jobs' do
      expect(chef_run).to include_recipe('devops-jenkins::jobs')
    end

    it 'include the mountpoint recipe' do
      expect(chef_run).to include_recipe('devops-jenkins::mountpoint')
    end
  end
end
