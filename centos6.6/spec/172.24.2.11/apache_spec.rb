require 'spec_helper'
require 'yaml'

parsed = begin
  config = YAML.load(File.open("./spec/settings.yml"))
rescue ArgumentError => e
  puts "Could not parse YAML: #{e.message}"
end

describe 'Apache' do
  puts ('Ejecutando pruebas de apacahe')

  describe command('apachectl -V') do
    its(:stdout) { should contain('Prefork').from(/^Server MPM/).to(/^Server compiled/) }
  
    its(:stdout) { should contain('conf/httpd.conf').after('SERVER_CONFIG_FILE') }
  
    its(:stdout) { should contain("Apache/#{config['apache_version']}").before('Server built') }
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
end

