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
    $nerr = 0
    #puts "La ip local es  #{host_inventory['network']}"
  }
  after(:each) do |test| 
    if test.exception != nil
      $nerr+=1
      $errores = $errores << "\n{panel:title=Error (#{$nerr}): } \n{code:java}\n{"
      $errores = $errores << test.exception.to_s
      $errores = $errores << "\n{code}\n{panel}"
    end
  end
  after(:all) {
    if $config['update_jira'] == true
      if $errores == "" 
        $errores = "No se han encontrado errores durante las pruebas."
        $execution.create($config['jira_project_id'],$config['jira_linux_id'],'Linux tests superados',$errores)
      else
        $execution.create($config['jira_project_id'],$config['jira_linux_id'],'Errores detectados en linux',$errores)
      end 
    end
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
      its(:stdout) {
        should contain('174.').from('eth1').to('Bcast')
      }
    end
  end

end
