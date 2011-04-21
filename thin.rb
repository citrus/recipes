## = = = = = = = = = = = = = ##
##   THIN SERVER
## = = = = = = = = = = = = = ##

namespace :deploy do
 
  namespace :thin do
  
    [:start, :stop, :restart].each do |action|
      
      desc "#{action} thin cluster"    
      task action, :roles => :app do
        run "cd #{current_path}; bundle exec thin #{action} -C #{server_config}"
      end
    
    end
   
    desc "Configure thin cluster"    
    task :configure, :roles => :app do
      sudo "thin config -C #{server_config} -c #{current_path} -p #{server_port} -e #{environment} -s #{servers}" 
    end
  
  end
    
  desc "Custom restart task for thin cluster"
  task :restart, :roles => :app, :except => { :no_release => true } do
    thin.restart
  end

  desc "Custom start task for thin cluster"
  task :start, :roles => :app do
    thin.start
  end

  desc "Custom stop task for thin cluster"
  task :stop, :roles => :app do
    thin.stop
  end

end
