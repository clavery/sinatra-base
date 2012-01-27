Database migrations for using sequel

Migrations are pretty simple:

# need the sequel gem and the database adapter
gem install sequel sqlite3
# from the project folder
sequel -m database/ sqlite://passman.db

Will run the migrations in this direction and create the sqlite3 database passman.db and track the migration version.

Simply create migrations using increasing version numbers for the filename. Dead simple.
