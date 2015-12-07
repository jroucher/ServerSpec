require 'spec_helper'

describe "jBoss", jboss:true do
  puts "Ejecutando pruebas de Jboss"
  describe user('jboss') do
    it { should exist }
  end
  
  describe group('jboss') do
    it { should exist }
  end
  
  describe user('jboss') do
    it { should belong_to_group 'jboss' }
  end
  
  describe file('/opt/app') do
    it { should be_directory }
    it { should be_owned_by 'jboss' }
    it { should be_grouped_into 'jboss' }
  end
  
  describe file('/etc/jboss-as') do
    it { should be_directory }
    it { should be_owned_by 'jboss' }
    it { should be_grouped_into 'jboss' }
  end
  
  describe file('/var/run/jboss-as') do
    it { should be_directory }
    it { should be_owned_by 'jboss' }
    it { should be_grouped_into 'jboss' }
  end
end
