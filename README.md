yogoshu [![Build Status](https://travis-ci.org/JongleurX/yogoshu.svg)](http://travis-ci.org/JongleurX/yogoshu) 
=======


A simple multilingual glossary in Ruby on Rails.

Installing
----------

To install the latest release of yogoshu, clone this repository:

```bash
git clone git://github.com/JongleurX/yogoshu.git
```

Requirements
------------
Everything is pretty straightforward except capybara-webkit, which is a giant pain in the ass to install, at least in Windows. It requires Qt 4.8.x libraries, which requires MinGW (Minimalist GNU utilities for Windows), and I spent nearly an entire day trying to get it to work before giving up and moving to Linux, which was still tricky. I'll have to follow up with more instructions later. In the end, I ended up commenting out the `gem capybara-webkit` line. I'll have to figure out how to get the tests working later.

Getting Started
---------------
It's tricky to create a user with a salted password since the database migrations don't create an initial front-end user for you. I'll have to document this later. In a nutshell, I had to launch the rails console (`rails c`), then create/save a new user (see the rails tutorial for details). Then I had to run the following few commands:

	require 'bcrypt'

	name = 'jeremy'
	salt = Digest::SHA1.hexdigest("--#{Time.now}--#{name}--")
	encrypted_password == User.encrypt('password', salt)

	puts salt
	puts encrypted_password```

To do this in the rails console:

	rails c
	irb(main):008:0> name = 'jeremy'
	irb(main):010:0> user = User.find(1)
	irb(main):011:0> salt = Digest::SHA1.hexdigest("--#{Time.now}--#{name}--")
	irb(main):013:0> encrypted_password = User.encrypt('password',salt)

There's probably an easier way, but I'm using SQLite for development, so I installed the SQLite Database Browser, then entered the salt and the encrypted password for the user I created via the rails console through the Database Browser front-end.

Configuration Options
---------------------
In `/config/initializers/yogoshu.rb`, you can set the "parent" language (the one that drives the others and always requires a term to be filled in for the entry), as well as define which other languages you want to include in your glossary. Below is an example of how to set up a hexalingual glossary driven by Japanese.

	# sets base languages to be used throughout the application
	Yogoshu::Locales.set_base_languages(:ja, :en, :fr, :es, :pt, :nl)

	# sets the default source language for all entries in the glossary
	Yogoshu::Locales.set_glossary_language :ja```

It's not really configuration, but you can batch-import terms by creating a CSV file that has a column for each language you enable in your glossary, then running a command like `rake csv:import[import_test.csv,importer]` (assuming you have created a user called `importer`). An example CSV file is shown below.

	"term_in_ja","term_in_en","term_in_fr","term_in_es","term_in_pt","term_in_nl"
	"ジャケット","jacket","blah","chaqueta","blah","blah"
	"卓球","ping pong","ping pong","blah","blah","blah"
	"建築","architecture","blah","arquitectura","blah","blah"


Copyright
---------
Copyright (c) 2014 Jeremy Bailey. See MIT-LICENSE for details.
Copyright (c) 2011 Chris Salzberg. See MIT-LICENSE for details.
