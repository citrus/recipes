## = = = = = = = = = = = = = ##
##   nginx
## = = = = = = = = = = = = = ##
  

def remote_file_exists?(full_path)
  'true' ==  capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip
end

def nginx_base_dir
  "/home/citrus/nginx"
end

def nginx_available(conf)
  File.join(nginx_base_dir, "available", "#{conf}.conf")
end

def nginx_enabled(conf)
  File.join(nginx_base_dir, "enabled", "#{conf}.conf")
end

def nginx_available?(conf)
  remote_file_exists? nginx_available(conf)
end

def nginx_enabled?(conf)
  remote_file_exists? nginx_enabled(conf)
end


  
namespace :deploy do
  namespace :nginx do
    
    desc "Uploads the vhost.conf file to the nginx folder."
    task :upload do
      conf = "config/" + (Dir.entries('config').select{|file| file.match('nginx.conf') != nil }[0]) rescue "nginx.conf"
      if conf && File.exists?(conf)
        if nginx_enabled?(application)
          run("rm #{nginx_enabled(application)}")
        end
        if nginx_available?(application)
          run("rm #{nginx_available(application)}")
        end
        put(File.read(conf), nginx_available(application), :mode => 0644)
      else
        puts "Create #{conf} then re-run `cap deploy:upload_vhost_conf` before proceeding..."
      end
    end
    
    desc "Enables the vhost.conf"
    task :enable do
      if nginx_available?(application)
         if nginx_enabled?(application)
           run("rm #{nginx_enabled(application)}")
         end
         run("ln -s #{nginx_available(application)} #{nginx_enabled(application)}")
         restart
      else
        puts "First run `cap deploy:nginx:upload` then re-run this task..."
      end
    end 
    
    
    desc "Disables the vhost.conf"
    task :disable do
      if nginx_enabled?(application)
         run("rm #{nginx_enabled(application)}")
         restart
      else
        puts "Application is not enabled. Run `cap deploy:nginx:enable` to enable..."
      end
    end 
    
    
    
    desc "Restarts Nginx"
    task :start do
      sudo("/etc/init.d/nginx start")
    end
    
    desc "Restarts Nginx"
    task :restart do
      sudo("/etc/init.d/nginx restart")
    end
        
  end

end