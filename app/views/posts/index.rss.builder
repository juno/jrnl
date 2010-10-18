xml.instruct! :xml, :version => "1.0", :encoding => "UTF-8"
xml.rss('version' => '2.0', 'xmlns:atom' => 'http://www.w3.org/2005/Atom', 'xmlns:openSearch' => 'http://a9.com/-/spec/opensearchrss/1.0/') do
  xml.channel do
    xml.title "Sooey"
    xml.description "duh"
    xml.link(request.protocol + request.host_with_port + url_for(:rss => nil))
    xml.language "ja-ja"

    xml.ttl "40"
    xml.pubDate(Time.now.strftime("%a, %d %b %Y %H:%M:%S %Z"))
    @posts.each do |e|
      xml.item do
        xml.title(e.title)
        xml.link(request.protocol + request.host_with_port +
                 url_for(:controller => 'posts', :action => 'show', :id => e.id ))
        xml.description(e.html)
        xml.guid(request.protocol + request.host_with_port +
                 url_for(:controller => 'posts', :action => 'show', :id => e.id ))
        xml.pubDate(e.created_at)
        xml.author 'Junya Ogura'
      end
    end
  end
end
