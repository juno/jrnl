atom_feed do |feed|
  feed.title("Sooey")
  feed.updated((@posts.first.created_at))

  for entry in @posts
    feed.entry(entry) do |item|
      item.title(entry.title)
      item.content(entry.html, :type => 'html')
      item.author "Junya Ogura"
    end
  end
end
