Just Some Cap Recipes
=====================

These have been evolving from various projects of mine... Hopefully you'll find them useful too!

Installation
------------

I put my recipes in `config/recipes` and modify my Capfile to look for them there:

    # Capfile
    load 'deploy' if respond_to?(:namespace)
    Dir['config/recipes/*.rb'].each { |recipe| load(recipe) }
    load 'config/deploy'



Some tips
---------

* Use `sample.deploy.rb` as a base. Note the DEV variable...
* The nginx recipe looks for `your_app_name.nginx.conf` in your config/ directory... Checkout `sample.nginx.conf` for an example...
* The database recipe looks for different versions of database.yml too... `database.yml.dev && database.yml.pro`
* The thin and recipe uses sudo for `thin config`
* Log rotate uses sudo since it modifies your `/etc/logrotate.conf`
* The shared_assets recipe is useful for [Spree](http://spreecommerce.com) sites that don't use capistrano's shared `system` folder
* `tailer.rb` can take some arguments: `cap deploy:tail log=custom len=200` (log defaults to "production" and len is "-f" by default to follow the log as it's being written)


License
-------

Copyright (c) 2011 Spencer Steffen and Citrus, released under the New BSD License All rights reserved.