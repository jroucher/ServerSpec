require 'spec_helper'
require 'yaml'

parsed = begin
  config = YAML.load(File.open("./spec/settings.yml"))
rescue ArgumentError => e
  puts "Could not parse YAML: #{e.message}"
end

describe 'Mongod' do 
  puts('Ejecutando puebas de MongoDB')

  describe command('mongod --version') do 
    its(:stdout) { should contain(config['mongo_version']).after('db version') }
  end
end
