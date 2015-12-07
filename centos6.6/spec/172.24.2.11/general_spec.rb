require 'spec_helper'
require 'specinfra'

distro = host_inventory['platform'].to_s

describe "Operating System", linux:true do
  before(:all) { 
    puts "\nEjecutando pruebas generales"
    puts "La distro empleada es: #{distro}"
    puts "SDA device size: #{host_inventory['block_device']['sda']['size']}"
    puts "SDA-1 device size: #{host_inventory['filesystem']['/dev/sda1']['kb_size']}"
    puts "SDA-2 device size: #{host_inventory['filesystem']['/dev/sda2']['kb_size']}"
    puts "SWAP device size: #{host_inventory['memory']['swap']['total']}"
    puts "Memoria Total: #{host_inventory['memory']['total']}"
    $errores = ""
    #puts "La ip local es  #{host_inventory['network']}"
  }
  after(:each) do |test| 
    if test.exception != nil
      $errores = $errores << "\nError en: #{test.description}"
    end
  end
  after(:all) {
    puts $errores
    $execution.create($config['jira_project_id'],$config['jira_linux_id'],'Errores detectados en linux',$errores)
  }

  describe distro do
    it {should match('redhat')}
  end

  describe "Disk size" do
    describe host_inventory['memory']['swap']['total'].to_i do
      it {should >= $config['swap_size']}
    end
    describe host_inventory['filesystem']['/dev/sda2']['kb_size'].to_i do
      it {should >= $config['disk2_size']}
    end
    describe host_inventory['filesystem']['/dev/sda1']['kb_size'].to_i do
      it { should >= $config['disk1_size']}
    end
  end
    


  describe "Memory" do
    describe host_inventory['memory']['total'].to_i do
      it {should >= $config['memory_size']}
    end 
  end



   describe "Network" do #new
      describe interface ("eth1") do 
        it {should exist}
      end
     
      describe command("ifconfig") do
        it(:stdout) {should contain('172.').from(/^eth1/).to(/^Bcast/)}
      end
   end
   


end
