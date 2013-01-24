if Rails.env.production?
  Analytics.init(secret: ENV['ANALYTICS_SECRET'])
end
