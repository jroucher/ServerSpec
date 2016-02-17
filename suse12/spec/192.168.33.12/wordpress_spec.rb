require 'spec_helper'

describe "WordPress", wordpress:true do
  before(:all) {
    $errores = ""
    $nerr = 0
    puts "\nEjecutando pruebas de wordpress"
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
        $errores = "\nNo se han encontrado errores durante las pruebas."
        $execution.create($config['jira_project_id'],$config['jira_wordpress_id'],'WordPress tests superados',$errores)
      else
        $execution.create($config['jira_project_id'],$config['jira_wordpress_id'],'Errores detectados en WordPress',$errores)
      end
    end
  }
  

  describe command("wp user get #{Shellwords.shellescape($config['admin_user'])} --format=json | jq -r .roles") do
    let(:disable_sudo) { true }
    its(:exit_status) { should eq 0 }
    its(:stdout){ should eq 'administrator' + "\n" }
  end
  
  describe command("wp eval 'echo get_locale();'") do
    let(:disable_sudo) { true }
    its(:exit_status) { should eq 0 }
    its(:stdout){ should eq $config['lang'] }
  end
  
  describe command("wp eval \"bloginfo('name');\"") do
    let(:disable_sudo) { true }
    its(:exit_status) { should eq 0 }
    its(:stdout){ should eq $config['title'] }
  end
  
  describe command("wp option get permalink_structure") do
    let(:disable_sudo) { true }
    its(:exit_status) { should eq 0 }
    its(:stdout){ should eq $config['rewrite_structure'] + "\n" }
  end
  
  $config['plugins'].each do |plugin|
    describe command("wp --no-color plugin status " + Shellwords.shellescape(plugin)) do
      let(:disable_sudo) { true }
      its(:exit_status) { should eq 0 }
      its(:stdout){ should match /Status: Active/ }
    end
  end
  
  describe command("wp --no-color theme status " + Shellwords.shellescape($config['theme'])) do
    let(:disable_sudo) { true }
    its(:exit_status) { should eq 0 }
    its(:stdout){ should match /Status: Active/ }
  end
  
  $config['options'].each do |key, value|
    describe command("wp option get " + Shellwords.shellescape(key)) do
      let(:disable_sudo) { true }
      its(:exit_status) { should eq 0 }
      its(:stdout){ should eq value + "\n" }
    end
  end
end
