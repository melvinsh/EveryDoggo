require 'json'
require 'open-uri'
require 'http'

File.readlines('words.txt').each do |word|
  word.strip!

  filename = "images/#{word} doggo.png"
  next if File.exist? filename

  puts "Searching #{word} doggo..."
  url = "http://api.ababeen.com/api/images.php?q=#{word}+dog&count=2"

  begin
    response = HTTP.get(url)
    data = JSON.parse(response)
  rescue JSON::ParserError
    puts 'Hit the rate limit, retrying later.'
    sleep 60
    retry
  end

  image_url = data[0]['url']
  backup_url = data[1]['url']

  puts image_url

  begin
    puts "Downloading #{word} doggo..."
    download = open(image_url)
    IO.copy_stream(download, filename)
  rescue => e
    puts e
    puts 'Retrying with backup.'
    puts backup_url
    download = open(backup_url)
    IO.copy_stream(download, filename)
  end
end
