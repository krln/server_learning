# config valid only for current version of Capistrano
lock '3.3.5'

set :application, 'server_learning'
set :repo_url, 'git@github.com:krln/server_learning.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app_name
#set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/sockets', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :deploy do

  task :start => [:set_rails_env] do
    on roles(:all) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rails, "server ", "--daemon"
        end
      end
    end
  end

  task :stop do
    execute :kill, "-TERM $(cat tmp/pids/server.pid)"
  end
  desc "Restart the application"
  task :restart do
    invoke "deploy:stop"
    invoke "deploy:start"
  end
end
