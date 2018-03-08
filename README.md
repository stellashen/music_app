# Music App

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

## Migration
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

## Model
Create user model & write methods for authentication:
1. add validations
2. Write methods to deal with the session token: `User::generate_session_token`,  `User#reset_session_token!` and `User#ensure_session_token`.
3. Write a `User#password=(password)` method which actually sets the password_digest attribute using [BCrypt][bcrypt-documentation], and a `User#is_password?(password)` method to check the users' password when they log in.
4. use an `after_initialize` callback to set the session_token before validation if it's not present. ("The after_initialize callback will be called whenever an Active Record object is instantiated, either by directly using new or when a record is loaded from the database." - From Docs)
5. Write a `User::find_by_credentials(email, password)` method.

## Controller
Create `UsersController` and `SessionsController`.

## Routes
Add routes in the routes.rb file.
``
    session POST   /session(.:format)                     sessions#create
            DELETE /session(.:format)                     sessions#destroy
new_session GET    /session/new(.:format)                 sessions#new
      users POST   /users(.:format)                       users#create
   new_user GET    /users/new(.:format)                   users#new
       user GET    /users/:id(.:format)                   users#show
```
