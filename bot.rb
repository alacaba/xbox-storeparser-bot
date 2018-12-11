require 'telegram/bot'
require 'xbox/storeparser'
require 'dotenv'

Dotenv.load

token = ENV['TELEGRAM_BOT_TOKEN']

CHUNK_SIZE = 20.freeze

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |msg|
    _, *params = msg.text.split

    if msg.text.include?('/deals')
      deals     = Xbox::Storeparser::Deals.new(locale: 'en-US')
      my_deals  = deals.fetch
      my_deals = my_deals.map(&:to_s)

      (0..my_deals.length).step(CHUNK_SIZE).each do |chunk|
        first, last = chunk, (chunk+CHUNK_SIZE)
        deals = (first..last).map { |i| my_deals[i] }.join("\n")
        bot.api.send_message(
          chat_id: msg.chat.id,
          text: deals,
          parse_mode: "markdown")
      end
    end

    if msg.text.include?('/help')
      instructions = "How to use /deals : \n\n"
      instructions += "1.) /deals <int> will list deals less than or equal to 10 USD \n\n"
      instructions += "2.) /deals <country> will list all deals on selected xbox regions\n\n"
      instructions += "supported regions: [ CA, US, DE, AU, UK ]"
      bot.api.send_message(
        chat_id: msg.chat.id,
        text: instructions,
        parse_mode: "markdown",
      )
    end
  end
end
