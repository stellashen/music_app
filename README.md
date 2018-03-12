# Music App

##Setup

## Users

## Bands

## Views

## Mailer

## Testing Rails With RSpec and Capybara

## Setup
1. create new project:
$ rails new music_app --database=postgresql

2. Under Gemfile, add gems to development group:
```
# Run 'bundle exec annotate' in Terminal to add helpful comments to models.
gem 'annotate'

# These two give you a great error handling page.
# But make sure to never use them in production!
gem 'better_errors'
gem 'binding_of_caller'

# Gotta have byebug...
gem 'byebug'

# pry > irb
gem 'pry-rails'
```

3. install gems:
$ bundle install

## Users
### Migration
Create users table:

$ rails g migration CreateUsers

In the users table, add fields: email, password_digest and session_token. Add index to email and session_token to speed up the lookup, and ensure uniqueness.

```
$ rails db:create
Created database 'music_app_development'
Created database 'music_app_test'
$ rails db:migrate
```

Check schema.rb

### Model
Create user model & write methods for authentication:
1. add validations
2. Write methods to deal with the session token: `User::generate_session_token`,  `User#reset_session_token!` and `User#ensure_session_token`.
3. Write a `User#password=(password)` method which actually sets the password_digest attribute using [BCrypt][bcrypt-documentation], and a `User#is_password?(password)` method to check the users' password when they log in.
4. use an `after_initialize` callback to set the session_token before validation if it's not present. ("The after_initialize callback will be called whenever an Active Record object is instantiated, either by directly using new or when a record is loaded from the database." - From Docs)
5. Write a `User::find_by_credentials(email, password)` method.

### Controller
Create `UsersController` and `SessionsController`.
Add methods in `ApplicationsController`.

### Routes
Add routes in the routes.rb file.
```
    session POST   /session(.:format)                     sessions#create
            DELETE /session(.:format)                     sessions#destroy
new_session GET    /session/new(.:format)                 sessions#new
      users POST   /users(.:format)                       users#create
   new_user GET    /users/new(.:format)                   users#new
       user GET    /users/:id(.:format)                   users#show
```

## Bands
### Migration and Model
$ rails g migration CreateBands

Add name field to bands table.

$ rails db:migrate

Add validation to Band model.

Add routes

### Routes
Add bands routes. Set root to /bands.
```
bands     GET    /bands(.:format)                       bands#index
          POST   /bands(.:format)                       bands#create
new_band  GET    /bands/new(.:format)                   bands#new
edit_band GET    /bands/:id/edit(.:format)              bands#edit
band      GET    /bands/:id(.:format)                   bands#show
          PATCH  /bands/:id(.:format)                   bands#update
          PUT    /bands/:id(.:format)                   bands#update
          DELETE /bands/:id(.:format)                   bands#destroy
```
Check what routes we have now:
$ rails routes

### Controller
Implement CRUD functionality.

### Users can add new bands to the website
$ rails g migration AddColumnToBands

add user_id to bands table

$ rails db:migrate

add validation under band model

add associations under User and Band models

## Views
Add basic views for users and bands.

Some details:
1. layouts

User layouts/application.html.erb as the layout for every view.

Add `yield: footer`.

In helpers/application_helper.rb, write helper method auth_token.

2. partial forms

User partial form `bands/_form.html.erb` for edit and new views for bands.

User partial form `shared/_errors.html.erb` for displaying flash errors.

3. In gemfile, add:
gem 'bcrypt'

## Mailer
New users will receive an email after signing up. (This function haven't been fully implemented. Now we'll just see a preview in browser.)
```
$ rails generate mailer UserMailer
```
Gemfile:
```
gem 'letter_opener'
```
config/environments/development.rb:
```
config.action_mailer.delivery_method = :letter_opener
```
users_controller.rb:
```
msg = UserMailer.welcome_email(@user)
msg.deliver_now
```
app/mailers/user_mailer.rb
```
class UserMailer < ApplicationMailer
  default from: 'notifications@example.com'

  def welcome_email(user)
    @user = user
    @url  = 'localhost:3000/new/session'
    mail(to: user.email, subject: 'Welcome to the Music App')
  end
end
```
Add email content in:

app/views/user_mailer/welcome_email.html.erb

app/views/user_mailer/welcome_email.txt.erb

user_mailer_preview.rb
```
class UserMailerPreview < ActionMailer::Preview
  def welcome_email
    UserMailer.welcome_email(User.first)
  end
end
```

## Testing Rails With RSpec and Capybara

Follow the instructions for setting up [RSpec-Rails][rspec-rails], [Shoulda Matchers][shoulda-matchers-docs], and [Capybara][capybara].

```ruby
  # Gemfile

  group :test do
    gem 'factory_bot_rails'
    gem 'faker'
    gem 'capybara'
    gem 'launchy'
    gem 'shoulda-matchers'
    gem 'rspec-rails'
  end
```

```ruby
  # database.yml

  test:
    adapter: postgresql
    database: music_app_test
    pool: 5
    timeout: 5000
```

```ruby
  # test.rb

  # Configure default mail server
  Rails.application.routes.default_url_options[:host] = 'domain.com'
```

```ruby
  # rails_helper.rb
  require 'shoulda/matchers'
  # put the following code under: RSpec.configure do |config|
  Shoulda::Matchers.configure do |config|
    config.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end
```



### Model Tests
Run `rails generate rspec:model User` to generate a spec file for the `User` model.

Use Should Matchers to validate:
* Presence of `email`
* Presence of `password_digest`
* Length of `password` > 6

Refer to [the docs][shoulda-matchers-docs] as needed.

Also, write methods to test `#is_password?`, `#reset_session_token`, and `::find_by_credentials`.

Run the specs (`bundle exec rspec spec/models`) to check.
