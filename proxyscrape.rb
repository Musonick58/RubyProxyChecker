require 'nokogiri'
require 'mechanize'
require 'active_support/all'
class ProxyScrape

  def initialize(url)
    @url = url
    @mechanize = @mechanize = Mechanize.new { |agent|
      agent.user_agent_alias = 'Mac Safari'
    }; nil
    @result = nil 
    @lines = []
    @mechanizeProxy = nil
  end

def scrapeProxy()
  @result = @mechanize.get(@url).content
  doc = Nokogiri::HTML(@result)
  # File.open("./proxylist.txt", "w") { |file|
  #  doc.css("tbody tr").each_with_index{ |tr,i|
  #    protocol = (tr.elements[6].text=='yes') ? "https://" : "http://"
  #    #puts tr.elements[5].text
  #    puts "#{i}: #{protocol}#{tr.elements[0].text}:#{tr.elements[1].text}"
  #    file.write("#{protocol}#{tr.elements[0].text}:#{tr.elements[1].text}\n");
  #    }
  #}
  doc.css("tbody tr").each_with_index{ |tr,i|
    protocol = (tr.elements[6].text=='yes') ? "https://" : "http://"
    puts "#{i}: #{protocol}#{tr.elements[0].text}:#{tr.elements[1].text}"
    @lines << "#{protocol}#{tr.elements[0].text}:#{tr.elements[1].text}\n";
  }
end


def testAndSave(filepath,urlToTest)
  raise "Execute scrapeProxy() first!" if @result == nil
  protocol = "http://"
  File.open(filepath,"w"){|x| } 
  	@lines.each{ |l|
      protocol = l["https"] || l["http"]
  		ip = l.gsub("https://","").gsub("http://","").split(":")[0]
  		port = l.gsub("https://","").gsub("http://","").split(":")[1]
  		@mechanizeProxy = Mechanize.new { |agent|
  		  agent.user_agent_alias = 'Mac Safari'
  		  agent.set_proxy(ip.to_s,port.to_i)
  		}; nil
  		begin
  			result = @mechanizeProxy.get(urlToTest).content
  			puts "It works! #{protocol}://#{ip}:#{port}"
  			File.open(filepath,"a"){ |f|
  				f.write("#{protocol}://#{ip}:#{port}")
  			}
  		rescue Exception => e 
  			puts "It doesn't work!"
  			puts e
  		end
  }
  end


end

ps = ProxyScrape.new("https://free-proxy-list.net/")
ps.scrapeProxy()
ps.testAndSave("./proxyTested.txt","https://www.google.it/")