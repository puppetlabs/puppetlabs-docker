require 'rake'
require 'parallel_tests'

# We clear the Beaker rake tasks from spec_helper as they assume
# rspec-puppet and a certain filesystem layout
Rake::Task[:beaker_nodes].clear
Rake::Task[:beaker].clear

desc "Run acceptance tests"
RSpec::Core::RakeTask.new(:acceptance => :spec_prep) do |t|
  t.pattern = 'spec/acceptance'
end


namespace :acceptance do
  {
    :vagrant => [
       'centos-66-x64',
       'centos-70-x64',
       'debian-78-x64',
       'debian-81-x64',
       'ubuntu-12042-x64',
       'ubuntu-1404-x64',
    ],
    :pooler => [
      'redhat-7-x86_64'
    ]
  }.each do |ns, configs|
    namespace ns.to_sym do
      configs.each do |config|
          desc "Run acceptance tests for #{config} on #{ns} with PE #{version}"
          RSpec::Core::RakeTask.new("#{config}_#{version}".to_sym => [:spec_prep, :envs]) do |t|
            ENV['BEAKER_PE_DIR'] = pe_dir
            ENV['BEAKER_keyfile'] = '~/.ssh/id_rsa-acceptance' if ns == :pooler
            ENV['BEAKER_debug'] = true if ENV['BEAKER_DEBUG']
            ENV['BEAKER_set'] = "#{ns}/#{config}"
            t.pattern = 'spec/acceptance'
          end
      end
    end
end