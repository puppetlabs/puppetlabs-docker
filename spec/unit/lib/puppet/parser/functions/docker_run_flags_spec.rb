require 'spec_helper'

describe 'the "docker_run_flags" parser function' do
  before :each do
    Puppet[:modulepath] = 'spec/fixtures/modules'
  end

  let :scope do
    node     = Puppet::Node.new('localhost')
    compiler = Puppet::Parser::Compiler.new(node)
    scope    = Puppet::Parser::Scope.new(compiler)
    allow(scope).to receive(:environment).and_return(nil)
    allow(scope).to receive(:[]).with('facts').and_return({ 'os' => { 'family' => os_family } })
    scope
  end

  context 'on POSIX system' do
    let(:os_family) { 'Linux' }

    it 'escapes special chars' do
      expect(scope.function_docker_run_flags([{ 'env' => [%.MYSQL_PASSWORD='"$()[]{}<>.], 'extra_params' => [] }])).to eq(%(-e MYSQL_PASSWORD\\=\\'\\"\\$\\(\\)\\[\\]\\{\\}\\<\\> \\\n))
    end
  end

  context 'on windows' do
    let(:os_family) { 'windows' }

    it 'escapes special chars' do
      expect(scope.function_docker_run_flags([{ 'env' => [%.MYSQL_PASSWORD='"$()[]{}<>.], 'extra_params' => [] }])).to eq(%^-e MYSQL_PASSWORD=`'\\`"`$()[]{}<> \\\n^)
    end
  end
end
