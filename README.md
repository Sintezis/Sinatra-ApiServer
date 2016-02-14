Sinatra API Server
====

Sinatra API Server is a library of preprepared code for handling data manipulation HTTP requests, and authenticating and creating API users. The server comes with provisioned vagrant box. 

Prequisits
----

+ Vagrant
+ VirtualBox (or other type of vritualisation engine)

Description
----

Vagrant Ruby Box comes with the following tools:

+ rbenv ruby manager
+ postgresql database
+ ngnix server 
+ thin ruby server
+ ruby bundler
+ sinatra framework

Config
------
API Server comes with a basic `api_config.yaml` file, here your db credentials along with ruby version are set. This config will affect your installed postgresql DB settings and will setup sinatra [data mapper](https://www.datamapper.org
) module config accordingly 

```
	# RBENV
	rbenv_root: /usr/local/rbenv
	ruby_version: 2.0.0-p353

	#NGINX
	config_file_path: files/nginx.conf

	#DB SETUP
	db_name: ruby_server_db
	db_user: ruby_developer
	db_user_password: developer
```
Sinatra specific config is in rack file, `config.ru`

Installation
-----

+ clone or downlod the repository
+ `cd` to project folder in terminal
+ run `vagrant up`, get some coffee...
+ run `vagrant status` to verify virtual machine status
+ in your browser visit `www.server.dev`, you shold get `404` response from working nginx server 	
+ login to your ruby box, run `vagrant ssh`
+ `cd /var/www/app` this is where your code is synced on guest machine, as specified in Vagrantfile
+ run `thin start` to start thin server, you should see a smiliar response: 

> 
```
Using rack adapter
Thin web server (v1.6.4 codename Gob Bluth)
Maximum connections set to 1024
Listening on 0.0.0.0:3000, CTRL+C to stop
```

Your api server is now runing on `server.dev:3000` in development mode, meaning if the code throws errors you will see them printed in terminal. To stop the server press `ctrl + c` in terminal. 

Thin can also run as daemon, run `thin -C /var/www/app/thin/config.yaml -d start`. Daemon is configured with thin config file `thin/config.yaml`, where you can find logs locations and relevant data.

API Documentation
----

Detailed documentation is hosted on [apiary](www.apiary.io): [http://docs.sinatraapiserver.apiary.io/#](http://docs.sinatraapiserver.apiary.io/#)









