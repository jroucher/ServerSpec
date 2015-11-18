require 'spec_helper'

describe "WordPress", wordpress:true do
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
