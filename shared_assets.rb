## = = = = = = = = = = = = = ##
##   shared assets
## = = = = = = = = = = = = = ##
  
namespace :deploy do

  namespace :assets do
  
    desc "Completes the entire share task"
    task :share do
      create_share_folder
      copy_assets
      symlink
    end
  
    desc "Create shared asset folder"
    task :create_share_folder do
      dir = "#{shared_path}/assets"
      unless capture("ls #{shared_path}").include?("assets")
        run("mkdir -p #{dir}")
      end
    end
    
    desc "Copies assets to shared folder"
    task :copy_assets do
      src = "#{current_path}/public/assets/*"
      dest  = "#{shared_path}/assets"
      if capture("ls #{current_path}/public").include?("assets")
        run "mv #{src} #{dest}"
      end
    end
    
    desc "Symlink shared assets"
    task :symlink do      
      src  = "#{shared_path}/assets"
      dest = "#{current_path}/public/assets"
      if capture("ls #{current_path}/public").include?("assets")
        run("mv #{dest} #{dest}_bak")
      end            
      run("ln -s #{src} #{dest}")      
    end
    
  end
  
end
