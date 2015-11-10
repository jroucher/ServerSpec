require 'spec_helper'
require 'specinfra'

describe "Operating System" do
  distro = host_inventory['platform'].to_s
  puts "La distro empleada es: #{distro}"
  describe distro do
    it {distro.should match "windows"}
  end

  describe command('WMIC LOGICALDISK where drivetype=3 get size') do
    its(:stdout) {should match /Size(.|\n|\r)*53316939776/ }
  end

  describe port(80) do
    it { should be_listening }
  end

  describe command('& ipconfig') do
    its(:stdout) { should contain("172.24.2.12") }
  end

  describe command('WMIC memorychip get capacity') do
    its(:stdout) {should match /(.|\n|\r)*1073741824/ }
  end
end


#describe "Memory" do
##  pending
##  puts "Memoria Total: #{host_inventory['memory']['total']}"
##  it "Total memory" do
##    host_inventory['memory']['total'].to_i.should >= 1000000
##  end 
#end


#describe iis_website('Default Website') do
#  it { should exist }
#  it { should be_enabled }
#  it { should be_running }
#  it { should have_physcal_path('C:\\inetpub\\www') } 
#end


