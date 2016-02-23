require 'spec_helper'
require 'pp'

class JiraRuby
  
  @client = nil
  
  def initialize
    username = $config["jira_user"]
    password = $config["jira_pass"]
    options = {
              :username  => username,
              :password  => password,
              #:site      => 'https://jirapdi.tid.es',
              :site      => 'https://pre-epg-jira-01',
  	      :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE,
              :context_path => '',
              :auth_type => :basic
            } 
    @client = JIRA::Client.new(options)
  end

  def create(project, parentId, summary, description)
    issue2 = @client.Issue.build
    result=issue2.save({"fields"=>{
    		"parent" => {"id" => parentId.to_s},
    		"summary" => summary,
  		"description" =>  description,
    		"project" => {"id" => project.to_s},
    		"issuetype" => {"id" => "13"}
    	    }})
    if result
      puts "\nExecution '#{summary}' create successfully"
    else
      puts "\nExecution '#{summary}' produce error in creation"
    end
    issue2.fetch
  end #def
end #class  
