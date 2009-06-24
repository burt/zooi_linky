# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_zooi_linky_session',
  :secret      => '0e7a0917224514d82a21b691fb3d0df763e3a8f6c5c71bde16c440b600c7a8c81d74cb3c548fb2a3b4e18e58e1189adb6f3f10fa646db2018f2bc3013ceb1b75'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
