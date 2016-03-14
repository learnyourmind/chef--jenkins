require 'spec_helper'

describe 'devops-jenkins::mountpoint' do
  # Serverspec examples can be found at
  # http://serverspec.org/resource_types.html
  mounts = [{ path: '/var/lib/jenkins', owner: 'jenkins', group: 'jenkins', mode: '750' }]

  mounts.each do |mnt|
    ## All mount points should be mounted, not just be directories
    it "#{mnt[:path]} is mounted" do
      expect(file mnt[:path]).to be_mounted
    end

    ## Expect all mounts points to be owned by the correct user
    it "#{mnt[:path]} is owned by user #{mnt[:owner]}" do
      expect(file mnt[:path]).to be_owned_by(mnt[:owner])
    end

    ## Expect all mounts points to be owned by the correct user
    it "#{mnt[:path]} is owned by group #{mnt[:group]}" do
      expect(file mnt[:path]).to be_grouped_into(mnt[:group])
    end

    ## Expect all mounts points to be have the correct mode
    it "#{mnt[:path]} has mode of #{mnt[:mode]}" do
      expect(file mnt[:path]).to be_mode(mnt[:mode])
    end
  end
end
