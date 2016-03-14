require 'chefspec'
require 'chefspec/berkshelf'
require 'tmpdir'

at_exit { ChefSpec::Coverage.report! }

RSpec.configure do |config|
  devops_jenkins = { temp_path: nil }

  config.add_setting :devops_jenkins
  config.devops_jenkins = devops_jenkins

  config.before(:suite) do
    devops_jenkins[:temp_path] = Dir.mktmpdir
  end

  config.after(:suite) do
    FileUtils.remove_entry_secure devops_jenkins[:temp_path]
  end
end
