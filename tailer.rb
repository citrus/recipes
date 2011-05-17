## = = = = = = = = = = = = = ##
##   log tailer
## = = = = = = = = = = = = = ##

def remote_file_exists?(full_path)
  'true' ==  capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip
end

namespace :deploy do
  
  desc "Tail a log file on the server. (production by default)"
  task :tail, :role => [:app] do
  
    log_file = (ENV['log'] || "production").sub(/\.log$/, '')
    log_file = "thin.#{server_port}" if log_file == "thin"
    log_file = "#{shared_path}/log/#{log_file}.log"
    
    puts "*" * 88
    
    if remote_file_exists?(log_file)
      length = ENV['len'].to_i
      length = 0 < length ? length : "-f"      
      run "tail -#{length} #{log_file}" do |channel, stream, data|
        puts data if stream == :out 
        if stream == :err 
          puts "[Error: #{channel[:host]}] #{data}"
          break
        end
        trap("INT") { puts "\n"; exit }
      end
    else
      puts "#{log_file} does not exist!"
    end
    
  end
end