## = = = = = = = = = = = = = ##
##   COMPRESS ASSETS
## = = = = = = = = = = = = = ##

require 'fileutils' unless defined?(FileUtils)


def remote_file_exists?(full_path)
  'true' ==  capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip
end

namespace :deploy do
  
  desc "Uses the YUI compresser on all JS/CSS, then uploads to server"
  task :compress_and_upload do
    yui_compress
    upload_compressed
    
    jq_core = "#{current_path}/public/javascripts/jquery-core.js"
    if remote_file_exists?(jq_core)
      run("rm #{jq_core}")
    end
    
    FileUtils.rm_r('public/compressed')
  end
  
  desc "Uses the YUI compresser on all JS/CSS"
  task :yui_compress do
    yui = '/usr/local/yui/build/yuicompressor-2.4.2.jar'
    if File.exists?(yui)
      compressed = 'public/compressed'
      FileUtils.mkdir_p compressed      
      ['javascripts','stylesheets'].each do |dir|
        files = Dir.entries("public/#{dir}").reject{|f| f.match(/\.(js|css)$/) == nil }
        puts "Compressing #{files.length} #{dir}!"
        out = compressed + "/#{dir}"
        FileUtils.remove_dir(out, true) if File.directory?(out)
        FileUtils.mkdir_p out
        files.each do |f|
          print " - compressing #{f}. "
          file = File.expand_path("public/#{dir}/" + f)
          new_file = File.join(File.expand_path('public'), 'compressed', dir, f)
          `java -jar #{yui} #{file} -o #{new_file}`
          puts " done."
        end
      end
    else
      puts "Please make sure that '#{yui}' exists."
    end
  end
  
  desc "Uploads the public/compressed files to the server"
  task :upload_compressed do
    
    ['javascripts','stylesheets'].each do |dir_name|
      dir = "public/compressed/#{dir_name}"
      if File.directory?(dir)        
        dir = File.expand_path dir
        to_dir = "#{current_path}/public"
        cmd = "scp -r -P #{port} #{dir} #{user}@#{domain}:#{to_dir}"
        puts cmd 
        `#{cmd}`
      else
        puts "#{dir} does not exist! Run `cap:deploy:yui_compress` to create.."
      end    
    end
    
  end
      
end
