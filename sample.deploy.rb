set :application, "your_app_name"
set :webpath,     "your_domain.com"
set :server_port, 3000

# a simple flag to switch between staging/development and live servers
DEV = false

if DEV
  set :user,      "username"
  set :domain,    "xx.xx.xx.xx"
  set :port,      22
else
  set :user,      "username"
  set :domain,    "xx.xx.xx.xx"
  set :port,      22
end

set :repository,  "ssh://git@xx.xx.xx.xx:22/home/git/projects/#{application}.git"

set :servers,     3

set :deploy_to,     "/home/#{user}/domains/#{webpath}"
set :server_config, "/etc/thin/#{application}.yml"

set :scm,         :git
set :use_sudo,    false
set :deploy_via,  :remote_cache

role :web,        "#{domain}"
role :app,        "#{domain}"
role :db,         "#{domain}", :primary => true

set :environment,   "production"

default_run_options[:pty] = true


namespace :deploy do
  
  before "deploy:cold" do
    setup
  end
  
  # kind of a hack ...
  desc "creates and migrates the database"
  task :migrate do
    run("bundle install --gemfile #{release_path}/Gemfile --without development test")
    run("cd #{release_path}; bundle exec rake db:create db:migrate")
  end
    
  after "deploy:symlink" do
    upload_database_yml
    assets.share
  end
  
  after "deploy:migrate" do
    thin.config
    nginx.upload
    nginx.enable
  end
  
  after "deploy" do
    cleanup
  end
  
end