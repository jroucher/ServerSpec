require 'spec_helper'

describe command('apachectl -V') do
  puts ('Ejecutando pruebas de apacahe')
  # test 'Prefork' exists between "Server MPM" and "Server compiled"
  its(:stdout) { should contain('Prefork').from(/^Server MPM/).to(/^Server compiled/) }

  # test 'conf/http.conf' exists after "Server_Config_File"
  its(:stdout) { should contain('conf/httpd.conf').after('SERVER_CONFIG_FILE') }

  #test 'Apache/2.2.29' exists before "Server built"
  its(:stdout) { should contain('Apache/2.2.15').before('Server built') }
end

describe user('apache') do
  it { should belong_to_group 'apache' }
end

describe package('httpd'), :if => os[:family] == 'redhat' do
  it { should be_installed }
end

describe port(80) do
  it { should be_listening }
end


