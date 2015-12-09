require 'spec_helper'

mysql_name = ''
case os[:family]
when 'ubuntu'
  mysql_name = 'mysql'
  mysql_config_file = '/etc/mysql/my.cnf'
  mysql_server_packages = %w{mysql-server apparmor-utils}
  collectd_plugin_dir = '/etc/collectd/plugins'
when 'redhat'
  mysql_name = 'mysqld'
  mysql_config_file = '/etc/my.cnf'
  mysql_server_packages = %w{mysql-server}
end

describe "MySQL", mysql:true do
  before(:all){
    puts "\nEjecutando pruebas de Mysql"
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
      $execution.create($config['jira_project_id'],$config['jira_mysql_id'],'MySQL tests superados',$errores)
    else
      $execution.create($config['jira_project_id'],$config['jira_mysql_id'],'Errores detectados en MySQL',$errores)
    end
  }

  describe "MySQL server packages are installed" do
    mysql_server_packages.each do |pkg|
      describe package(pkg) do
        it { should be_installed }
      end
    end
  end
  
  describe service(mysql_name) do
  #  it { should be_enabled }
    it { should be_running }
  end
  
  describe port($config['mysql_port']) do
    it { should be_listening }
  end
  
  describe file(mysql_config_file) do
    it { should be_file }
  end
    
  describe command('mysql -h localhost -V') do 
    its(:stdout) { should contain($config['mysql_version']).after('mysql  Ver 14.14 Distrib ') }
  end
 end 
