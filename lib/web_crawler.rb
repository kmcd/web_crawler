require 'open-uri'
require 'nokogiri'
require 'tempfile'
require 'logger'
require 'algorithms'

# Fetches all pages from a starting URL (Breadth first)
class Crawler
  def initialize(starting_url)
    @queue = Containers::Queue.new [starting_url] # Can this be a set Q ?
    @repository = Dir.mktmpdir
    @log = Logger.new STDOUT
  end
  
  def start
    until @queue.empty?
      url = @queue.pop
      page = fetch_page url
      
      enqueue urls_extracted_from(page, url)
      save_to_disk page, url
    end
  end
  
  private
  
  def fetch_page(url)
    open(url).read
    # TODO: use DNS cache to prevent duplicate lookup
  end
  
  def urls_extracted_from(page,url)
    Nokogiri::HTML(page).xpath("//a/@href").map do |element| 
      canonicalise element.value, url
    end
  end
  
  def enqueue(urls)
    urls.each {|url| @queue << url }
  end
  
  def canonicalise(href,url)
    return href if href =~ /http:\/\//
    "#{url}/#{href}"
  end
  
  def save_to_disk(page,url)
    uri = url.gsub /\//, '_'
    saved_page = Tempfile.new [uri, ''], @repository
    saved_page << page
    saved_page.close
  end
  
  def log(message)
    @log.info message
  end
end