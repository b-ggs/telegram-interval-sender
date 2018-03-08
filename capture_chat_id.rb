require 'yaml'
require 'telegram/bot'

token = YAML.load_file('config.yml')['token']

def save_chat_id(chat_id)
  File.open('.chat_id', 'w') do |file|
    file.puts chat_id
  end
end

def on_start(bot, message)
  chat_id = message.chat.id
  username = message.from.username
  resp = "#{username} (#{chat_id}) will now begin receiving messages from telegram-interval-sender."
  bot.api.send_message(
    chat_id: chat_id,
    text: resp
  )
  save_chat_id(chat_id)
  puts resp
  exit
end

puts 'Waiting for message from user...'

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text
    when '/start'
      on_start(bot, message)
    end
  end
end
