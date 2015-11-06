require 'spec_helper'
require 'specinfra'

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
  collectd_plugin_dir = '/etc/collectd.d'
end

describe "MySQL server packages are installed" do
  mysql_server_packages.each do |pkg|
    describe package(pkg) do
      it { should be_installed }
    end
  end
end

describe service(mysql_name) do
  it { should be_enabled }
  it { should be_running }
end

describe port(3306) do
  it { should be_listening }
end

describe file(mysql_config_file) do
  it { should be_file }
end
