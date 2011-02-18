require 'uri'
require 'net/dns/resolver'

class DnsCache
  HostNames = Hash.new do |hash,key|
    ip_address = []
    Net::DNS::Resolver.start(key).each_address {|a| ip_address << a.to_s }
    hash[key] = ip_address.first.to_s
  end
  
  def self.resolve(url)
    domain_name = URI.parse(url).host
    ip_address = HostNames[domain_name]
    
    url.sub domain_name, ip_address
  end
end
