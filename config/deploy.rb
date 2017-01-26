lock "3.7.1"

set :application, "qna"
set :repo_url, "git@github.com:ditch0/qna.git"

set :deploy_to, "/home/ubuntu/qna"
set :deploy_user, "ubuntu"

append :linked_files, "config/database.yml", "config/secrets.yml", ".env", "config/production.sphinx.conf"
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "public/uploads"

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'unicorn:restart'
    end
  end
  after :publishing, :restart
end

after :deploy, 'thinking_sphinx:rebuild'
