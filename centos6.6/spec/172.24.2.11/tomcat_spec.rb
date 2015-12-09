require 'serverspec'
require 'specinfra'


describe 'Tomcat', tomcat:true do
  before(:all) {
    puts "\nEjecutando pruebas de Tomcat"
    $errores = ""
  }
  after(:each) do |test| 
    if test.exception != nil
      $errores = $errores << "\nError en: #{test.description}"
    end
  end
  after(:all) {
    puts $errores
    if $errores == "" 
      $errores = 'No se han encontrado errores durante las pruebas.'
      $execution.create($config['jira_project_id'],$config['jira_tomcat_id'],'TomCat tests superados',$errores)  
    else
      $execution.create($config['jira_project_id'],$config['jira_tomcat_id'],'Errores detectados en TomCat',$errores)  
    end
  }
  

  describe 'Tomcat Daemon' do
    it 'is listening on port 8080' do
      expect(port($config['tomcat_port'])).to be_listening
    end
    it 'has a running service of tomcat' do
      expect(service('tomcat7')).to be_running
    end
  end
  
  describe group('tomcat') do
    it { should exist }
  end
  
  describe user('tomcat') do
    it { should exist }
    it { should belong_to_group 'tomcat' }
  end
  
  describe file('/opt/tomcat') do
    it { should be_directory }
  end
  
  describe file('/opt/tomcat/bin/catalina.sh') do
    it { should be_owned_by 'tomcat' }
    it { should be_executable.by_user('tomcat') }
    it { should be_writable.by_user('tomcat') }
    it { should be_readable.by_user('tomcat') }
  end
   
  describe file('/opt/tomcat/conf/server.xml') do
    it { should be_owned_by 'tomcat' }
    it { should be_writable.by_user('tomcat') }
    it { should be_readable.by_user('tomcat') }
  end
end
