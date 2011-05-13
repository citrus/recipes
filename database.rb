## = = = = = = = = = = = = = ##
##   database
## = = = = = = = = = = = = = ##

def remote_file_exists?(full_path)
  'true' ==  capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip
end
  
namespace :deploy do

  desc "Uploads the database.yml file to the shared folder."
  task :upload_database_yml do
    yml = "config/database.yml.#{defined?(DEV) && DEV ? 'dev' : 'pro'}"
    if File.exists?(yml)
      put(File.read(yml), "#{shared_path}/database.yml", :mode => 0644)
      deploy.share_database_yml
    else
      puts "Create #{yml} then re-run `cap deploy:upload_database_yml` before proceeding..."
    end
  end 
    
  desc "Symlinks the db file.."
  task :share_database_yml do
    yml = 'database.yml'
    if remote_file_exists?("#{current_path}/config/#{yml}")
      run("rm #{current_path}/config/#{yml}")
    end
    run("ln -s #{shared_path}/#{yml} #{current_path}/config/#{yml}")
  end  
  
end
