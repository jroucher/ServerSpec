require 'spec_helper'


describe "jBoss", jboss:true do
  before(:all){
    puts "\nEjecutando pruebas de Jboss"
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
      $execution.create($config['jira_project_id'],$config['jira_jboss_id'],'jBoss tests superados',$errores)
    else
      $execution.create($config['jira_project_id'],$config['jira_jboss_id'],'Errores detectados en jBoss',$errores)
    end
  }

  describe user('jboss') do
    it { should exist }
  end
  
  describe group('jboss') do
    it { should exist }
  end
  
  describe user('jboss') do
    it { should belong_to_group 'jboss' }
  end
  
  describe file('/opt/app') do
    it { should be_directory }
    it { should be_owned_by 'jboss' }
    it { should be_grouped_into 'jboss' }
  end
  
  describe file('/etc/jboss-as') do
    it { should be_directory }
    it { should be_owned_by 'jboss' }
    it { should be_grouped_into 'jboss' }
  end
  
  describe file('/var/run/jboss-as') do
    it { should be_directory }
    it { should be_owned_by 'jboss' }
    it { should be_grouped_into 'jboss' }
  end
end
