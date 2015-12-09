require 'spec_helper'


describe 'node', node:true do
  before(:all) {
    puts "\nEjecutando pruebas de nodeJS"
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
      $execution.create($config['jira_project_id'],$config['jira_node_id'],'NodeJS tests superados',$errores)
    else
      $execution.create($config['jira_project_id'],$config['jira_node_id'],'Errores detectados en NodeJS',$errores)
    end
  }

 
  describe command("node --version") do
    its(:stdout) { should contain($config['node_version']) }
  end
  
end
#  describe command("node -V") do
#    its(:stdout) {should_not  contain("-bash")}#si contiene -bash  es porque no se ha abierto node, por tanto no esta instalado..
#  end
