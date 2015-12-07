require 'spec_helper'


describe command("node --version"), node:true do
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
    $execution.create($config['jira_project_id'],$config['jira_node_id'],'Errores detectados en NodeJS',$errores)
  }

  its(:stdout) { should contain($config['node_version']) }

end
#  describe command("node -V") do
#    its(:stdout) {should_not  contain("-bash")}#si contiene -bash  es porque no se ha abierto node, por tanto no esta instalado..
#  end
