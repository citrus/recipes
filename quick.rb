## = = = = = = = = = = = = = ##
##   quick git based deploy
## = = = = = = = = = = = = = ##

namespace :deploy do
  
  desc "Just executes `git pull origin master` on the server"
  task :quick, :role => [:app] do
     
    run "cd #{current_path} && git pull origin master" do |channel, stream, data|
      
      #channel.send_data "PASSWORD\n" if data =~ /password:/
      
      puts data if stream == :out 
      
      if stream == :err 
        puts "[Error: #{channel[:host]}] #{data}"
        break
      end
      
      trap("INT") { puts "\n"; exit }
      
    end
        
  end
end
