require 'rubygems'
require 'benchmark'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
require 'web_crawler'

def benchmark(message)
  puts "= #{message}"
  puts Benchmark.measure { Crawler.new('http://www.dmoz.org').start(10) }
  puts 
end

benchmark "With DNS caching using IP address instead of hostname"

class Crawler
  private
  
  def fetch_page(url)
    open(url).read
  end
end

benchmark "Without DNS caching using hostname"
