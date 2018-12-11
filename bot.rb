require 'telegram/bot'
require 'xbox/storeparser'
require 'dotenv'

Dotenv.load

token = ENV['TELEGRAM_BOT_TOKEN']

CHUNK_SIZE = 20.freeze
deals      = Xbox::Storeparser::Deals.new(locale: 'en-US')
my_deals   = deals.fetch

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |msg|
    _, *params = msg.text.split

    if msg.text.include?('/deals')
      fmt_deals = my_deals.map(&:to_s)

      (0..fmt_deals.length).step(CHUNK_SIZE).each do |chunk|
        first, last = chunk, (chunk+CHUNK_SIZE)
        deals = (first..last).map { |i| fmt_deals[i] }.join("\n")
        bot.api.send_message(
          chat_id: msg.chat.id,
          text: deals,
          parse_mode: "markdown")
      end
    end
  end
end
