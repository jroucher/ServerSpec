require 'rubygems'
require 'pp'
require 'jira'


username = "vdc.ruby"
password = "VDC.ruby"

options = {
            :username  => username,
            :password  => password,
            :site      => 'https://pre-epg-jira-01',
	    :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE,
            :context_path => '',
            #:context_path => '/secure/Dashboard.jspa',
	    #:use_ssl   => true,
            :auth_type => :basic
          }

client = JIRA::Client.new(options)

#if ARGV.length == 0
#  # If not passed any command line arguments, open a browser and prompt the
#  # user for the OAuth verifier.
#  request_token = client.request_token
#  puts "Opening #{request_token.authorize_url}"
#  system "open #{request_token.authorize_url}"
#
#  puts "Enter the oauth_verifier: "
#  oauth_verifier = gets.strip
#
#  access_token = client.init_access_token(:oauth_verifier => oauth_verifier)
#  puts "Access token: #{access_token.token} secret: #{access_token.secret}"
#elsif ARGV.length == 2
#  # Otherwise assume the arguments are a previous access token and secret.
#  access_token = client.set_access_token(ARGV[0], ARGV[1])
#else
#  # Script must be passed 0 or 2 arguments
#  raise "Usage: #{$0} [ token secret ]"
#end

# Show all projects
projects = client.Project.all

projects.each do |project|
  puts "Project -> key: #{project.key}, name: #{project.name}"
end
#issue = client.Issue.find('SAMPLEPROJECT-1')
#pp issue
