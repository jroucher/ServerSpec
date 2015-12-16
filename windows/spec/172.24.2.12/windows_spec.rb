require 'spec_helper'

describe "Operating System", windows: true do
  before(:all){
    distro = host_inventory['platform'].to_s
    puts "\nEjecutando pruebas #{distro}"
    $errores = ""
    $nerr = 0
  }
  after(:each) do |test|
    if test.exception != nil
      $nerr += 1
      $errores = $errores << "\n{panel:title=Error (#{$nerr}): } \n{code:java}\n{"
      $errores = $errores << test.exception.to_s
      $errores = $errores << "\n{code}\n{panel}"
    end
  end 
 
  after(:all) {
    if $config['update_jira'] == true
      if $errores == ""
        $errores = 'No se han encontrado errores durante las pruebas.'
        $execution.create($config['jira_project_id'],$config['jira_win_id'],'Windows tests superados',$errores)
      else
        $execution.create($config['jira_project_id'],$config['jira_win_id'],'Errores detectados en Windows',$errores)
      end
    end
  }

  describe host_inventory['platform'] do
    it {distro.should match "windows"}
  end

  # tamaño del disco
  describe command('WMIC LOGICALDISK where drivetype=3 get size') do
    its(:stdout) {should match /Size(.|\n|\r)*#{$config['win_disk1_size']}/ }
  end

  # tiene ip asignada
  describe command('& ipconfig') do
    its(:stdout) { should contain("172.") }
  end
  
  # tamaño de la memoria
  describe command('WMIC memorychip get capacity') do
    its(:stdout) {should match /(.|\n|\r)*1073741824/ }
  end
end
