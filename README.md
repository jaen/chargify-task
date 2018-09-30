# chargify-task

Just your ye olde Railse applicatione for the Chargify recruitment task.

The usual stuff works:

  * `rake db:migrate` to migrate the database,
  * `rake db:seed` to seed the datbase (required for `SubscriptionLevel`s to exist)
  * `rails s` runs the app with Puma,
  * `rails c` opens a Pry console with the application environment,
  * `bundle exec guard` watches the tests,
  * `rails rdoc:rdoc` builds documentation.

Also has some unusual stuff:

  * `logic/validators` is a directory of API parameters validations
  * `logic/transactions` is a directory of API transactions, decoupled from persistence models.
