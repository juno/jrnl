xml.instruct! :xml, :version => "1.0", :encoding => "UTF-8"
xml.rss('version' => '2.0', 'xmlns:atom' => 'http://www.w3.org/2005/Atom') do
  xml.channel do
    xml.title "Sooey"
    xml.description "duh"
    xml.link(request.protocol + request.host_with_port + url_for(:rss => nil))
    xml.language "ja"

    xml.ttl "40"
    xml.pubDate(Time.now.strftime("%a, %d %b %Y %H:%M:%S %Z"))

    @posts.each do |e|
      xml.item do
        date = e.created_at.strftime("%a, %d %b %Y %H:%M:%S %Z")
        xml.title(e.title)
        xml.link(request.protocol + request.host_with_port + permalink_path(:id => e.id))
        xml.description(e.html)
        xml.guid(request.protocol + request.host_with_port + permalink_path(:id => e.id))
        xml.pubDate(date)
        xml.author 'junyaogura@gmail.com (Junya Ogura)'
      end
    end
  end
end
