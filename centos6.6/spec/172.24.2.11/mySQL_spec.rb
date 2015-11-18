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
  
  describe port(3306) do
    it { should be_listening }
  end
  
  describe file(mysql_config_file) do
    it { should be_file }
  end
    
  describe command('mysql -h localhost -V') do 
    its(:stdout) { should contain($config['mysql_version']).after('mysql  Ver 14.14 Distrib ') }
  end
 end 
