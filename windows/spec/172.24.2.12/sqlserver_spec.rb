require 'spec_helper'

describe 'SQL Server 2014', mssql: true do
  before(:all){
    puts "\nLanzando pruebas de SQLserver"
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
        $execution.create($config['jira_project_id'],$config['jira_mssql_id'],'MS SQL tests superados',$errores)
      else
        $execution.create($config['jira_project_id'],$config['jira_mssql_id'],'Errores detectados en MS SQL',$errores)
      end
    end
  }

  describe service('SQL Server (MSSQLSERVER)') do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
    it { should have_start_mode('Automatic') }
  end

  describe package($config['mssql_package_name']) do
    it { should be_installed }
  end

  describe port($config['mssql_port']) do
    it { should be_listening.with('tcp') }
  end
end
