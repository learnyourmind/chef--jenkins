#
# Cookbook Name:: devops-jenkins
# Spec:: mountpoint
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

require 'spec_helper'

config = { data_dir: { path: '/var/lib/jenkins', size: '100%FREE', fstype: 'ext4' } }

describe 'devops-jenkins::mountpoint' do
  context 'When all attributes are default, on an instance without partitions created for Jenkins' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      chef_run # This should not raise an error
    end

    it 'installs `di-ruby-lvm` as a Ruby gem' do
      expect(chef_run).to install_chef_gem('di-ruby-lvm')
    end

    vg_name = 'vg_jen'
    vg_devices = ['/dev/vdb']

    it "creates a physical volume '#{vg_name}'" do
      expect(chef_run).to create_lvm_volume_group(vg_name).with(physical_volumes: vg_devices)
    end

    config.each do |key, value|
      path   = value[:path]
      size   = value[:size]
      fstype = value[:fstype]

      it "creates a logical volume for '#{key}'" do
        expect(chef_run).to create_lvm_logical_volume(key)
          .with(group: vg_name, size: size, filesystem: fstype, mount_point: path)
      end

      it "confirms ownership and permissions on '#{path}'" do
        expect(chef_run).to create_directory(path).with(owner: 'root', group: 'root', mode: '0750')
      end
    end
  end
end
