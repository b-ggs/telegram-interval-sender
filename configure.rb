require 'yaml'

def project_path
  File.dirname(__FILE__)
end

def schedule_path
  File.expand_path(project_path, '.schedule.rb')
end

def messages
  YAML.load_file('messages.yml')
end

def schedule_template(options)
  every = options['every']
  message_path = options['message_path']
  <<-TEMPLATE
every #{every} do
  command '#{File.expand_path(File.join(project_path, message_path))}'
end
  TEMPLATE
end

Dir.chdir(project_path)

schedule_templates =
  messages.map do |message|
    schedule_template(message)
  end

schedule = schedule_templates.join("\n")

File.open(schedule_path, 'w') do |file|
  file.puts(schedule)
end

`whenever -f #{schedule_path} -i`
