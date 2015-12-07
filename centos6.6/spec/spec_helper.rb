require 'serverspec'
require 'net/ssh'
require 'yaml'

parsed = begin
  $config = YAML.load(File.open("./spec/settings.yml"))
rescue ArgumentError => e
  puts "Could not parse YAML: #{e.message}"
end

set :backend, :ssh

if ENV['ASK_SUDO_PASSWORD']
  begin
    require 'highline/import'
  rescue LoadError
    fail "highline is not available. Try installing it."
  end
  set :sudo_password, ask("Enter sudo password: ") { |q| q.echo = false }
else
  set :sudo_password, ENV['SUDO_PASSWORD']
end

host = ENV['TARGET_HOST']

options = Net::SSH::Config.for(host)

options[:user] ||= Etc.getlogin


set :host,        options[:host_name] || host
set :ssh_options, options

def createExecution(project, parentId, summary, description)
#def createExecution(project, parentId, summary, status, description)
  username = "vdc.ruby"
  password = "VDC.ruby"

  options = {
            :username  => username,
            :password  => password,
            #:site      => 'https://jirapdi.tid.es',
            :site      => 'https://pre-epg-jira-01',
	    :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE,
            :context_path => '',
            :auth_type => :basic
          }

  client = JIRA::Client.new(options)

  issue2 = client.Issue.build
  result=issue2.save({"fields"=>{
  		"parent" => {"id" => parentId.to_s},
  		"summary" => summary,
		#"status" => {"id"=>status},		# Aun no he encontrado como actualizar el status 
		"description" =>  description,
  		"project" => {"id" => project.to_s},
  		"issuetype" => {"id" => "13"}
  	    }})
  if result
    puts "Exection '#{summary}' create successfully"
  else
    puts "Exection '#{summary}' produce error in creation"
  end
  issue2.fetch
end

# Disable sudo
# set :disable_sudo, true


# Set environment variables
# set :env, :LANG => 'C', :LC_MESSAGES => 'C' 

# Set PATH
# set :path, '/sbin:/usr/local/sbin:$PATH'
