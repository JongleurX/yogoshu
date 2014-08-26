yogoshu [![Build Status](https://travis-ci.org/JongleurX/yogoshu.svg)](http://travis-ci.org/JongleurX/yogoshu) 
=======

A simple multilingual glossary in Ruby on Rails.

Disclaimer: This is a work in progress, and may be useful for small, informal projects, but I'm just beginning to learn Rails, and many features professional terminologists would like to use are not yet implemented. Here's a short list of features I'd like to add in the future (assuming I can gain the skill to do so, or the community can help out).

* Provide a way of having multiple "terms" per language for each "entry" (concept).
* Add ability to let a manager define entry-level and term-level tags; allow contributors to tag each entry and term.
	* This would provide a way of giving context (is the term OK for consumers, is it prohibited or deprecated, etc).
* Support for import from and export to TBX files (TBX-basic OK for now).
* Keep a log of failed term searches, that is sortable or filterable by number of hits (to reduce noise), and let managers convert a failed search into an entry.
* Provide a translation and approval workflow, with e-mail notifications.
* Implement a RESTful API so that third-party applications can query for terms and get matching results (this could be used to implement a prohibited term checker, for example).
* Add discussion boards with voting (like Stack Exchange) so users can use the tool for discussions, instead of e-mail or other means.
* Provide a more robust search and filtering system (wildcards, regex, showing terms that are blank in a certain language).
* Add a feature for language-specific term approval (instead of just the entry/concept level).

Installing
----------

To install the latest release of yogoshu, follow the instructions below. These instructions have been tested on Mac OS X 10.10 Beta 2 and Ubuntu 14.04.

In a terminal:

	git clone git://github.com/JongleurX/yogoshu.git
	cd yogoshu
	bundle install
	cp config/database_example.yml config/database.yml
	bundle exec rake db:migrate
	rails c

In the `irb` prompt:

	user = User.new(name: 'admin', password: 'admin', password_confirmation: 'admin')
	user.salt = Digest::SHA1.hexdigest("--#{Time.now}--#{user.name}--")
	user.encrypted_password = User.encrypt(user.password,user.salt)
	user.role = 'admin'	
	user.save
	exit

Back in the terminal:

	rails s

Finally, open a browser to http://0.0.0.0:3000/ and start hacking! In case it wasn't obvious from the command above, the default username and password is `admin`.

Requirements
------------
Everything is pretty straightforward except capybara-webkit, which is a giant pain in the ass to install, at least in Windows. It requires Qt 4.8.x libraries, which requires MinGW (Minimalist GNU utilities for Windows), and I spent nearly an entire day trying to get it to work before giving up and moving to Linux, which was still tricky. I'll have to follow up with more instructions later. In the end, I ended up commenting out the `gem capybara-webkit` line. I'll have to figure out how to get the tests working later.

Getting Started
---------------

Instead of entering all your terms and entries by hand, you can batch-import terms by creating a CSV file that has a column for each language you enable in your glossary, then running a command like like the following.

	rake csv:import[import_test.csv,admin]
	
An example CSV file is provided in the Git repository as `import_test.csv`, but the syntax is shown below.

	"term_in_ja","term_in_en","term_in_fr","term_in_es","term_in_pt","term_in_nl","term_in_de","term_in_it","term_in_ar"
	"コンピューター","computer","ordinateur (f)","computadora (f)","computador (m)","computer (m)","Rechner (m)","elaboratore (m)","الكمبيوتر"
	"卓球","ping pong","ping-pong","ping pong","ping pong","ping pong","Tischtennis","ping pong","بينج بونج"

You can create additional accounts by clicking on the **Manage Users** link in the menu at the top of the page. Below is an overview of how the permissions work.

* Managers (for example, the admin user)
	* Manage all users
	* Add entries
	* Edit entries
	* Delete entries
* Contributors (registered users that are not admins)
	* Add entries
    * View all entries
* Guests (users without accounts)
	* View approved entries


Configuration Options
---------------------
In `/config/initializers/yogoshu.rb`, you can set the "parent" language (the one that drives the others and always requires a term to be filled in for the entry), as well as define which other languages you want to include in your glossary. Below is an example of how to set up an octalingual glossary driven by Japanese.

	# sets base languages to be used throughout the application
	Yogoshu::Locales.set_base_languages(:ja, :en, :fr, :es, :pt, :de, :nl, :ar)

	# sets the default source language for all entries in the glossary
	Yogoshu::Locales.set_glossary_language :ja```

Copyright
---------
Copyright (c) 2014 Jeremy Bailey. See MIT-LICENSE for details.
Copyright (c) 2011 Chris Salzberg. See MIT-LICENSE for details.
