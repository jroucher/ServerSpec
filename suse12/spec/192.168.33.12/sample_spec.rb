require 'spec_helper'
require 'specinfra'

describe package('httpd'), :if => os[:family] == 'redhat' do
  it { should be_installed }
end

describe package('apache2'), :if => os[:family] == 'ubuntu' do
  it { should be_installed }
end

describe service('httpd'), :if => os[:family] == 'suse' do
  it { should be_enabled }
  it { should be_running }
end

describe service('httpd'), :if => os[:family] == 'redhat' do
  it { should be_enabled }
  it { should be_running }
end

describe service('apache2'), :if => os[:family] == 'ubuntu' do
  it { should be_enabled }
  it { should be_running }
end

describe service('org.apache.httpd'), :if => os[:family] == 'darwin' do
  it { should be_enabled }
  it { should be_running }
end

describe port(80) do
  it { should be_listening }
end

describe "distro" do
  puts "La distro empleada es: #{host_inventory['platform']}"
end

#describe "memtotal" do
#  puts "Memoria Total: #{host_inventory['memory']['total']}"
#end

#describe host('win-2012r2') do
#  its(:ipaddress) { should eq '192.168.33.20' } 
#end

#describe iis_website('WIN-2012R2') do
#  it { should exist }
#  it { should be_enabled }
#  it { should be_running }
#  it { should have_physcal_path('C:\\inetpub\\www') } 
#end
