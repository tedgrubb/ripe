set :application, "itsripe.com"
set :repository,  "ssh://admin@itsripe.com:30000/home/admin/repos/itsripe.com.git"

set :deploy_to, "/home/admin/public_html/itsripe.com"

set :scm, :git
default_run_options[:pty] = true
set :port, 30000
set :use_sudo, false

set :user, "admin"
role :app, "itsripe.com"
role :web, "itsripe.com"
role :db,  "itsripe.com", :primary => true

namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
    sudo "bash -c 'cd #{current_path} && rake solr:restart RAILS_ENV=#{fetch(:rails_env, "production")}'", :as => 'www-data'
  end
 
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
  
  desc "Link additional symlinks"
  task :additional_symlinks do
    run <<-CMD
      rm -rf #{latest_release}/solr &&
      ln -s #{shared_path}/solr #{latest_release}/solr &&
      rm -rf #{latest_release}/public/photos &&
      ln -s #{shared_path}/photos #{latest_release}/public/photos
    CMD
    
  end
  
  after "deploy:finalize_update", "deploy:additional_symlinks"
end

