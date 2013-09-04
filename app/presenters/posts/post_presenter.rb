class Posts::PostPresenter < Curly::Presenter
  presents :post

  def permalink
    link_to(@post.created_at, permalink_path(@post))
  end

  def raw_html
    raw(@post.html)
  end
end
