require 'spec_helper'

describe 'devops-jenkins::default' do
  # Serverspec examples can be found at
  # http://serverspec.org/resource_types.html
  it 'Install jenkins' do
    expect(package 'jenkins').to be_installed.by('rpm').with_version('1.652')
  end

  it 'Running Jenkins' do
    expect(service 'jenkins').to be_running
  end

  it 'Enabled jenkins' do
    expect(service 'jenkins').to be_enabled
  end

  it 'Jenkins user' do
    expect(user 'jenkins').to exist
  end

  it 'Jenkins Group' do
    expect(user 'jenkins').to belong_to_group 'jenkins'
  end

  it 'Jenkins Home dir' do
    expect(user 'jenkins').to have_home_directory '/var/lib/jenkins'
  end

  it 'Jenkins login SHELL' do
    expect(user 'jenkins').to have_login_shell '/bin/false'
  end

  it 'jenkins Service port 8080' do
    expect(port '8080').to be_listening
  end

  it 'Should be able to run chefdk smoke test job' do
    expect(command("java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080 build 'Chef Installed' -s -v").stdout).to match(/Finished: SUCCESS/)
  end
end
