require 'spec_helper'

describe 'NodeJS', node:true do 
  puts('Ejecutando puebas de NodeJS')

  describe command('node --version') do 
    its(:stdout) { should contain($config['node_version']) }
  end
end
