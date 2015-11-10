require 'spec_helper'
require 'yaml'

parsed = begin
  config = YAML.load(File.open("./spec/settings.yml"))
rescue ArgumentError => e
  puts "Could not parse YAML: #{e.message}"
end

describe 'NodeJS' do 
  puts('Ejecutando puebas de NodeJS')

  describe command('node --version') do 
    its(:stdout) { should contain(config['node_version']) }
  end
end
