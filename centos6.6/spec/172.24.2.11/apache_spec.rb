require 'spec_helper'

describe 'Apache', apache:true do
  before(:all) {
    $errores = ""
    puts "\nEjecutando pruebas de apache"
  }
  after(:each) do |test| 
    if test.exception != nil
      puts "\nError en: #{test.description}"
      $errores = $errores << "\nError en: #{test.description}"
    end
  end
  after(:all) { 
    puts $errores
    if $errores == "" 
      $errores = 'No se han encontrado errores durante las pruebas.'
      $execution.create($config['jira_project_id'],$config['jira_apache_id'],'Apache tests superados', $errores)
    else
      $execution.create($config['jira_project_id'],$config['jira_apache_id'],'Errores detectados en Apache', $errores)
    end
  }
  

  describe command('apachectl -V') do
    its(:stdout) { should contain('Prefork').from(/^Server MPM/).to(/^Server compiled/) }
  
    its(:stdout) { should contain('conf/httpd.conf').after('SERVER_CONFIG_FILE') }
  
    its(:stdout) { should contain("Apache/#{$config['apache_version']}").after('Server version') }
  end
  
  describe user('apache') do
    it { should belong_to_group 'apache' }
  end
  
  describe package('httpd'), :if => os[:family] == 'redhat' do
    it { should be_installed }
  end
  
  describe port($config['apache_port']) do
    it { should be_listening }
  end
  
  describe service('httpd') do
    it { should be_running }
  end
end
