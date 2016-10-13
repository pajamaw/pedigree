ENV['SINATRA_ENV'] ||= "development"

require 'bundler/setup'
Bundler.require(:default, ENV['SINATRA_ENV'])

require_all 'app'


configure :development do
  set :database, {
    adapter: 'postgresql',
    encoding: 'unicode',
    database: 'pedigree',
    pool: 2,
    username: '',
    password: 'password1'
  }
end

configure :production do
  set :database, {
    adapter: 'postgresql',
    encoding: 'unicode',
    database: 'pedigree',
    pool: 2,
    username: '',
    password: 'password1'
  }
end
