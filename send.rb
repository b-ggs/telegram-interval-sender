require 'yaml'
require 'telegram/bot'

token = YAML.load_file('config.yml')['token']

message = STDIN.read
chat_id = File.read('.chat_id').chomp

if chat_id == '' || message == ''
  exit 1
end

puts 'Sending message to user...'

Telegram::Bot::Client.run(token) do |bot|
  bot.api.send_message(
    chat_id: chat_id,
    text: message
  )
end

puts 'Sent message to user...'
