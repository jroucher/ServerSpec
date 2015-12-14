require 'spec_helper'


describe 'node', node:true do
  before(:all) {
    puts "\nEjecutando pruebas de nodeJS"
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
        $errores = 'No se han encontrado errores durante las pruebas.'
        $execution.create($config['jira_project_id'],$config['jira_node_id'],'NodeJS tests superados',$errores)
      else
        $execution.create($config['jira_project_id'],$config['jira_node_id'],'Errores detectados en NodeJS',$errores)
      end
    end
  }

 
  describe command("node --version") do
    its(:stdout) { should contain($config['node_version']) }
  end
  
end
#  describe command("node -V") do
#    its(:stdout) {should_not  contain("-bash")}#si contiene -bash  es porque no se ha abierto node, por tanto no esta instalado..
#  end
