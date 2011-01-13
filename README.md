jrnl
====

ready,

    $ bundle install
    $ bundle exec rake db:create
    $ bundle exec rake db:migrate

set,

    $ cp config/config.example.yml config/config.yml
    $ vi config/config.yml

    $ rails c
    > u = User.new
    > u.email = 'foo@example.com'
    > u.password = '*****'
    > u.password_confirmation = '*****'
    > u.save!

go!

    $ rails s

and test.

    $ RAILS_ENV=test bundle exec rake db:create
    $ rake spec
