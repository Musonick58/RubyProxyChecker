require 'nokogiri'
require 'mechanize'
require 'active_support/all'

@mechanize = Mechanize.new { |agent|
  agent.user_agent_alias = 'Mac Safari'
}; nil
@url = "https://free-proxy-list.net/"
@result = @mechanize.get(@url).content
doc = Nokogiri::HTML(@result)
 File.open("./proxylist.txt", "w") { |file|
  doc.css("tbody tr").each_with_index{ |tr,i|
    protocol = (tr.elements[6].text=='yes') ? "https://" : "http://"
    #puts tr.elements[5].text
    puts "#{i}: #{protocol}#{tr.elements[0].text}:#{tr.elements[1].text}"
    file.write("#{protocol}#{tr.elements[0].text}:#{tr.elements[1].text}\n");
    }
}
File.open("./proxytested.txt","w"){|x| }

File.open("./proxylist.txt", "r") { |io|  
	io.each{ |l|
		ip = l.gsub("https://","").gsub("http://","").split(":")[0]
		port = l.gsub("https://","").gsub("http://","").split(":")[1]
		@mechanize = Mechanize.new { |agent|
		  agent.user_agent_alias = 'Mac Safari'
		  agent.set_proxy(ip.to_s,port.to_i)
		}; nil
		begin
			@result = @mechanize.get("http://www.google.it").content
			puts "It works! #{ip}:#{port}"
			File.open("./proxytested.txt","a"){ |f|
				f.write("#{ip}:#{port}")
			}
		rescue Exception => e 
			puts "It doesn't work!"
			puts e
		end
		}
}


