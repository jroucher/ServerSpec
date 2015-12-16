require 'spec_helper'

describe "Internet Information System", iis: true do 
  before(:all){
    puts "\nLanzando pruebas de IIS"
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
        $execution.create($config['jira_project_id'],$config['jira_iis_id'],'IIS tests superados',$errores)
      else
        $execution.create($config['jira_project_id'],$config['jira_iis_id'],'Errores detectados en IIS',$errores)
      end
    end
  }

  describe port($config['iis_port']) do
    it { should be_listening }
  end
  
  describe iis_website('Default Website') do
    it{ should exist }
    it{ should be_enabled }
    it{ should be_running }
    it{ should have_physical_path($config['iis_folder']) } 
  end
end
