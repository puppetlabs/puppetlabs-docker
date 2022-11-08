require 'spec_helper'

describe 'the "docker_run_flags" parser function' do
  let :scope do
    node     = Puppet::Node.new('localhost')
    compiler = Puppet::Parser::Compiler.new(node)
    scope    = Puppet::Parser::Scope.new(compiler)
    allow(scope).to receive(:environment).and_return(nil)
    scope
  end

  it 'env with special chars' do
    expect(scope.function_docker_run_flags([{ 'env' => [%.MYSQL_PASSWORD='"$()[]{}<>.], 'extra_params' => [] }])).to match(/^-e MYSQL_PASSWORD\\=\\'\\"\\\$\\\(\\\)\\\[\\\]\\\{\\\}\\<\\> \\$/)
  end
end
