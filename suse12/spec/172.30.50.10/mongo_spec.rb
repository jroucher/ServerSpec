require 'spec_helper'


describe 'Mongod', mongo:true do 
  before(:all) {
    puts "\nEjecutando puebas de MongoDB"
    $errores = ""
    $nerr = 0
  }
  after(:each) do |test| 
    if test.exception != nil
      $nerr+=1
      $errores = $errores << "\n{panel:title=Error (#{$nerr}): } \n{code:java}\n{"
      $errores = $errores << test.exception.to_s
      $errores = $errores << "\n{code}\n{panel}"
    end
  end
  after(:all) {
    if $config['update_jira'] == true
      if $errores == "" 
        $errores = "No se han encontrado errores durante las pruebas."
        $execution.create($config['jira_project_id'],$config['jira_mongo_id'],'MongoDB tests superados',$errores)
      else
        $execution.create($config['jira_project_id'],$config['jira_mongo_id'],'Errores detectados en MongoDB',$errores)
      end
    end
  }

  describe command('mongod --version') do 
    its(:stdout) { should contain($config['mongo_version']).after('db version') }
  end
  
  describe service('mongod') do
    it {should be_enabled}
    it {should be_running}
  end
  
  describe port($config['mongo_port']) do
    it { should be_listening }
  end
end
