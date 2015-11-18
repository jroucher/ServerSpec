require 'spec_helper'

describe 'Mongod', mongo:true do 
#describe 'Mongod' do 
  puts('Ejecutando puebas de MongoDB')

  describe command('mongod --version') do 
    its(:stdout) { should contain($config['mongo_version']).after('db version') }
  end
  
  describe service('mongod') do
    it {should be_enabled}
    it {should be_running}
  end
end
