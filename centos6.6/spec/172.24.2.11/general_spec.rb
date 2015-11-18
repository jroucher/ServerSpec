require 'spec_helper'
require 'specinfra'

describe "Operating System", general:true do
#describe "Operating System" do
  distro = host_inventory['platform'].to_s
  puts "La distro empleada es: #{distro}"
  describe distro do
    it {should match('redhat')}
  end

  describe "Disk size" do
    puts "SDA device size: #{host_inventory['block_device']['sda']['size']}"
    puts "SDA-1 device size: #{host_inventory['filesystem']['/dev/sda1']['kb_size']}"
    puts "SDA-2 device size: #{host_inventory['filesystem']['/dev/sda2']['kb_size']}"
    describe host_inventory['filesystem']['/dev/sda2']['kb_size'].to_i do
      it {should >= $config['disk_size']}
    end
    describe host_inventory['filesystem']['/dev/sda2']['kb_size'].to_i do
      it { should >= $config['swap_size']}
    end
  end
  
  describe "Memory" do
    puts "Memoria Total: #{host_inventory['memory']['total']}"
    describe host_inventory['memory']['total'].to_i do
      it {should >= $config['memory_size']}
    end 
  end
end
