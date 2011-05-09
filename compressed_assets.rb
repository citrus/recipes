## = = = = = = = = = = = = = ##
##   compressed assets
## = = = = = = = = = = = = = ##

require 'fileutils' unless defined?(FileUtils)

YUI = '/usr/local/yui/build/yuicompressor-2.4.2.jar'
OUT = 'public/compressed'

def remote_file_exists?(full_path)
  'true' ==  capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip
end

def _yui_compress(pattern)
  files = Dir[pattern].reject{|f| f =~ /\/cache\// }
  raise "No Files Found" if files.length == 0
  
  FileUtils.mkdir_p OUT

  files.each do |f|
    print " - compressing #{f}. "
    _in  = File.expand_path(f)
    _out = _in.sub('/public/', '/public/compressed/')
    _dir = File.dirname(_out)
    FileUtils.mkdir_p(_dir) unless Dir.exists?(_dir)
    
    cmd = "java -jar #{YUI} #{_in} -o #{_out}"
    `#{cmd}`
    
    puts " done."
  end
end

namespace :deploy do
  
  desc "Uses the YUI compresser on all JS/CSS, then uploads to server"
  task :compress_upload_and_enable do
    compress.all
    upload_compressed
    css = "#{current_path}/public/stylesheets"
    if remote_file_exists?(css)
      run "rm -r #{css}"
    end    
    js = "#{current_path}/public/javascripts"
    if remote_file_exists?(js)
      run "rm -r #{js}"
    end
    enable_compressed
  end
  
  desc "Uploads the public/compressed files to the server"
  task :upload_compressed do
    raise "Compressed Directory not found" unless Dir.exists?(OUT)
    cmd = "scp -r -P #{port} #{OUT} #{user}@#{domain}:#{current_path}/public/"
    puts cmd
    `#{cmd}`
  end
    
  desc "Replaces the remote uncompressed versions with the compressed ones"
  task :enable_compressed do
    run "cd #{current_path}/public/compressed; mv ./stylesheets ../; mv ./javascripts ../"
  end
    
  namespace :compress do
    desc "Uses the YUI compresser on all JS/CSS"
    task :all do
      css
      js 
    end
    desc "Uses the YUI compresser on all stylesheets"
    task :css do
      puts "Compressing Stylesheets!"
      _yui_compress("public/stylesheets/**/*.css")      
    end
    desc "Uses the YUI compresser on all javscripts"
    task :js do
      puts "Compressing Javascripts!"
      _yui_compress("public/javascripts/**/*.js")
    end    
  end
      
end
