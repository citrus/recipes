Just Some Cap Recipes
=====================

These have been evolving from various projects of mine... Hopefully you'll find them useful too!


Some tips
---------

* Use `sample.deploy.rb` as a base. Note the DEV variable...
* The nginx recipe looks for `your_app_name.nginx.conf` in your config/ directory... Checkout `sample.nginx.conf` for an example...
* The database recipe looks for different versions of database.yml too... `database.yml.dev && database.yml.pro`
* The thin recipe uses sudo for `thin config`
* The shared_assets recipe is useful for [Spree](http://spreecommerce.com) sites that don't use capistrano's shared `system` folder

License
-------

Copyright (c) 2011 Spencer Steffen and Citrus, released under the New BSD License All rights reserved.