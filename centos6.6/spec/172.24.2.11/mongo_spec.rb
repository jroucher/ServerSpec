require 'spec_helper'

describe 'Mongod' do 
  puts('Ejecutando puebas de MongoDB')

  describe command('mongod --version') do 
    its(:stdout) { should contain('v3.0.7').after('db version') }
  end
end
