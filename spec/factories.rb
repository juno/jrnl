# -*- coding: utf-8 -*-

Factory.define :post do |p|
  p.content 'This is test post.'
end

Factory.define :author, :class => User do |u|
  u.email 'john.smith@example.com'
  u.password 'secret-phrase'
  u.password_confirmation 'secret-phrase'
end
