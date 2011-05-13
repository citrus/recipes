## = = = = = = = = = = = = = ##
##  log rotation
## = = = = = = = = = = = = = ##

namespace :deploy do

  desc "Configures logrotate"
  task :configure_log_rotate do
    
    
    text = %(
  
  #{current_path}/log/*.log {
    daily
    missingok
    rotate 7
    compress
    delaycompress
    notifempty
    copytruncate
  }
  
  )
  
    etc = "/etc/logrotate.conf"
    tmp = "tmp/logrotate.conf"
  
    get etc, "./#{tmp}"
    conf = File.expand_path("../../../#{tmp}", __FILE__)
    regex = Regexp.new(current_path + "/log")
    matches = File.read(conf).match(regex) || []
    
    puts File.read(conf)
        
    if 0 < matches.length
      puts "#{current_path} already exists in logrotate.conf.."
    else
      File.open(conf, 'a') {|file| file.write(text) }
      put(File.read(conf), "#{current_path}/#{tmp}", :mode => 0644)
      
      sudo("mv #{etc} #{etc}.bak")
      sudo("mv #{current_path}/#{tmp} #{etc}")
      sudo("/usr/sbin/logrotate -f #{etc}")
  
      puts "#{current_path} added to logrotate.conf."
    end
    
    File.delete(conf)
  
  end
  
end