require 'spec_helper'

describe "Internet Information System", iis: true do 
  puts('Lanzando pruebas de IIS')

  describe port(80) do
    it { should be_listening }
  end
  
  describe iis_website('Default Website') do
    it{ should exist }
    it{ should be_enabled }
    it{ should be_running }
    it{ should have_physical_path('C:\\inetpub\\www') } 
  end
end
