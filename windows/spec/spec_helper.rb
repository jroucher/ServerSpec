require 'serverspec'
require 'winrm'
require 'yaml'
require 'jira'
require 'jiraruby'
require 'specinfra'

#include SpecInfra::Helper::WinRM
#include SpecInfra::Helper::Windows

#RSpec.configure do |c|
#  c.host  = ENV['TARGET_HOST']
#  set_property properties[c.host]
#
#  user = "administrador"
#  pass = "VMware01!"
#  endpoint = "http://#{c.host}:5985/wsman"
#
#  c.winrm = ::WinRM::WinRMWebService.new(endpoint, :ssl, :user => user, :pass => pass, :basic_auth_only => true)
#  c.winrm.set_timeout 30
#end
parsed = begin
  $config = YAML.load(File.open("./spec/settings.yml"))
rescue ArgumentError => e
  puts "Could not parse YAML: #{e.message}"
end

$execution = JiraRuby.new

set :backend, :winrm
set :os, :family => 'windows'

user = 'administrador'
pass = 'VMware01!'
host = ENV['TARGET_HOST']
endpoint = "http://#{host}:5985/wsman"
puts ("Estableciendo conexion a < #{endpoint} >")	# DEBUGIN

winrm = ::WinRM::WinRMWebService.new(endpoint, :ssl, :user => user, :pass => pass, :basic_auth_only => true)
winrm.set_timeout 300 #  30 seconds max timeout for any operation
Specinfra.configuration.winrm = winrm
