require 'spec_helper'
require 'specinfra'
require 'yaml'

parsed = begin
  config = YAML.load(File.open("./spec/settings.yml"))
rescue ArgumentError => e
  puts "Could not parse YAML: #{e.message}"
end

describe "Operating System" do
  distro = host_inventory['platform'].to_s
  puts "La distro empleada es: #{distro}"
  describe 'redhat' do
    it {distro.should match('redhat')}

  end
end

describe "Disk size" do
  puts "SDA device size: #{host_inventory['block_device']['sda']['size']}"
  puts "SDA-1 device size: #{host_inventory['filesystem']['/dev/sda1']['kb_size']}"
  puts "SDA-2 device size: #{host_inventory['filesystem']['/dev/sda2']['kb_size']}"
  it "Principal HDD Should be 49gb" do
    host_inventory['filesystem']['/dev/sda2']['kb_size'].to_i.should >= config['disk_size']
  end
  it "Swap HDD Should be 250mb" do
    host_inventory['filesystem']['/dev/sda2']['kb_size'].to_i.should >= config['swap_size']
  end
end

describe "Memory" do
  puts "Memoria Total: #{host_inventory['memory']['total']}"
  it "Total memory" do
    host_inventory['memory']['total'].to_i.should >= config['memory_size']
  end 
end


#describe "memcached" do
#  pending
#  it "should use almost all memory" do
#    total = command("vmstat -s | head -1").stdout # 
#   total = /\d+/.match(total)[0].to_i
#   total /= 1024
#   args = process("memcached").args # 
#   memcached = /-m (\d+)/.match(args)[1].to_i
#   (total - memcached).should be > 0
#   (total - memcached).should be < 2000
# end
#end
