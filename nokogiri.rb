#comando para llamar gemas de ruby
require 'rubygems'
#comando para llamar a la gema nokogir 
require 'nokogiri'        
#comando para que abra la pagina web que se va a extraer
require 'open-uri'
 
 
class TwitterScrapper
 #Metodo initilize es el que recibe la pagina web y la sintaxis para configurar nokogiri 
  def initialize(url)
    @url = url 
    @page = Nokogiri::HTML(open(@url))
  end
 
 #Metodo que da formato
  def show_values
    stats = extract_stats
    p "Username: #{extract_username}"
    p "-"*90
    p "Stats: Tweets: #{stats[0]}, Siguiendo: #{stats[1]}, Seguidores:#{stats[2]}, Favoritos: #{stats[3]}"
    p "-"*90
    p "Tweets"
    extract_tweets
  end

 #Metodo que extrae el username de twitter 
  def extract_username
    user_name = @page.search(".ProfileHeaderCard-name")
    user_name.first.inner_text
  end
 
 #Metodo que extrae los tweets
  def extract_tweets
    tweet_text = []
    tweet_date = []
    retuit = []
    favorite = []
    content = @page.search(".content")
    content.each  do |t|
      retuit << t.search(".ProfileTweet-actionCountForPresentation").first.inner_text 
      favorite << t.search(".ProfileTweet-actionCountForPresentation").last.inner_text 
      tweet_date << t.search(".tweet-timestamp").inner_text
      tweet_text << t.search(".tweet-text").inner_text
    end
    #Repite el metdodo para todos los tweet listados
    repeat = tweet_text.count 
    num = 0
    until num == repeat
      p "#{tweet_date[num]} : #{tweet_text[num]}"
      p "Retweets: #{retuit[num]}, Favoritos: #{favorite[num]} "
      puts
      num += 1 
    end
  end
 
  #Metodo que extrae las estadisticas de los usuarios
  def extract_stats
    number_of_tweets = @page.search(".ProfileNav-value") 
    number_of_tweets.map do |tweet|
      tweet.inner_text
    end
  end
end
 
 
#Comado que hace interactivo el programa desde la terminal 
input = ARGV
objt = TwitterScrapper.new(input[0])
# p objt.extract_username
# p objt.extract_stats
objt.show_values
 