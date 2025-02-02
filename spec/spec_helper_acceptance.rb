require 'beaker-rspec'

unless ENV['RS_PROVISION'] == 'no'
  hosts.each do |host|
    if host.is_pe?
      install_pe
    else
      install_puppet
      on host, "mkdir -p #{host['distmoduledir']}"
    end
  end
end

UNSUPPORTED_PLATFORMS = ['windows'].freeze

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    puppet_module_install(source: proj_root, module_name: 'swap_file')
    hosts.each do |_host|
      shell('puppet module install puppetlabs-stdlib --version 4.7.0', { acceptable_exit_codes: [0] })
      shell('puppet module install herculesteam/augeasproviders_core --version 2.1.0', { acceptable_exit_codes: [0] })
      shell('puppet module install herculesteam/augeasproviders_sysctl --version 2.1.0', { acceptable_exit_codes: [0] })
    end
  end
end
