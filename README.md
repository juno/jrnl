jrnl
====

[![Travis](https://travis-ci.org/juno/jrnl.png)](https://travis-ci.org/juno/jrnl)
[![Gemnasium](https://gemnasium.com/juno/jrnl.png)](https://gemnasium.com/juno/jrnl/)
[![security](https://hakiri.io/github/juno/jrnl/master.svg)](https://hakiri.io/github/juno/jrnl/master)

Getting Start
-------------

ready,

    $ bundle --path vendor/bundles
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

Documentation
-------------

Generate API documents.

    $ bundle exec rake yard
    $ open doc/index.html

Testing
-------

Create test database.

    $ RAILS_ENV=test bundle exec rake db:create
    $ RAILS_ENV=test bundle exec rake db:migrate

Running tests.

    $ bundle exec rake spec

View coverage report.

    $ open coverage/index.html
