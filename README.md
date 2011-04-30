jrnl
====

ready,

    $ bundle --path vendor/bundles install
    $ bundle exec rake db:create
    $ bundle exec rake db:migrate

set,

    $ cp config/application.example.yml config/application.yml
    $ vi config/application.yml

    $ bundle exec rails c
    > u = User.new
    > u.email = 'foo@example.com'
    > u.password = '*****'
    > u.password_confirmation = '*****'
    > u.save!

go!

    $ bundle exec rails s

and test.

    $ RAILS_ENV=test bundle exec rake db:create
    $ bundle exec rake spec
    $ open coverage/index.html
