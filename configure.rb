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
  command = "cd #{File.expand_path(project_path)} && "
  command << "#{message_path} | "
  command << 'bundle exec ruby send.rb'
  <<-TEMPLATE
every #{every} do
  command '#{command}'
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

puts 'Successfully updated crontab!'
