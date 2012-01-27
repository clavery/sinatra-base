1. Setup gems

# bundle install

2. Migrate db and enter some test data

# rake db:migrate
# rake db:console

> u = User.new
> u.username = "chuck"
> u.password = "test"
> u.save
> f = Foobar.new
> f.name = "test foobar"
> f.save
> exit

or use rake tasks to add users "rake -T"

3. Run the test server

# rackup config.ru

4. Login and view your test data

# open http://localhost:9292/app/

