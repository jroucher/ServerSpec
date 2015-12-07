require 'rubygems'
require 'pp'
require 'jira'


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

# Show all projects
projects = client.Project.all

projects.each do |project|
  puts "Project -> [#{project.id}] key: #{project.key}, name: #{project.name}"
end

# issue del proyecto
#project = client.Project.find('VDC')
#pp project.name
#project.issues.each do |issue|
#  puts "#{issue.id} - (#{issue.issuetype.id} - #{issue.issuetype.name}) #{issue.fields['summary']}" 
#end
#if project.issues.count == 0
#  puts "\tNo Issues in project #{project.name}"
#end

# busqueda mediante JQL
#query_options = {
#        :fields => [],
#        :start_at => 0,
#        :max_results => 100000
#}
#client.Issue.jql('project = VDC  AND type="Test Case"', query_options).each do |issue|
#  pp "(#{issue.id}) #{issue.summary}"
#  
#end

## Mostrar los tipos
#client.Issuetype.all.each do |issue|
#  pp "(#{issue.id}) #{issue.name}"
#end

# Crear una ejecución
#issue = client.Issue.find('Apache')

#def createExecution(project, parentId, summary, description)
def createExecution(project, parentId, summary, status, description)
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
		"status" => {"id"=>status},		# Aun no he encontrado como actualizar el status 
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


#createExecution(32330, 1961395, "Mediante funcion", "Esta es una prueba para verificar que la automatizacion de PaaS guarda correctamente las ejecuciones")
createExecution(32330, 1961395, "Mediante funcion", "10006", "Esta es una prueba para verificar que la automatizacion de PaaS guarda correctamente las ejecuciones")
