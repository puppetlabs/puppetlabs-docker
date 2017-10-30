# Run a test task
require 'spec_helper_acceptance'

describe 'create container', if: pe_install? && puppet_version =~ %r{(5\.\d\.\d)} do 

  let(:pp) {"
              class { 'docker':
              }
            "}
  apply_manifest(pp, :catch_failures=>true)

  describe 'from dockerhub image' do
    it 'should create a docker image from local dockerfile' do
      result = run_task(task_name: 'from_dockerhub', params:'image=hello-world')
      expect(result).to match("Hello from Docker!")
    end
  end

  describe 'from local dockerfile' do
    it 'should create a docker image from dockerhub image' do
      result = run_task(task_name: 'from_dockerfile', params:"container_name=my-container dockerfile_path='.'")
      expect(result).to match("")
    end
  end
end
