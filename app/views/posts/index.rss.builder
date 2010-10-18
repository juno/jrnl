xml.instruct! :xml, :version => "1.0", :encoding => "UTF-8"
xml.rss('version' => '2.0') do
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
        xml.pubDate(e.created_at.strftime("%a, %d %b %Y %H:%M:%S %Z"))
        xml.author 'Junya Ogura &lt;junyaogura@gmail.com&gt;'
      end
    end
  end
end
