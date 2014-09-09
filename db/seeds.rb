# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

user = User.new(name: 'admin', password: 'admin', password_confirmation: 'admin')
user.salt = Digest::SHA1.hexdigest("--#{Time.now}--#{user.name}--")
user.encrypted_password = User.encrypt(user.password,user.salt)
user.role = 'manager' 
user.save

user = User.new(name: 'contributor', password: 'contributor', password_confirmation: 'contributor')
user.salt = Digest::SHA1.hexdigest("--#{Time.now}--#{user.name}--")
user.encrypted_password = User.encrypt(user.password,user.salt)
user.role = 'contributor' 
user.save

user = User.new(name: 'jens', password: 'secret', password_confirmation: 'secret')
user.salt = Digest::SHA1.hexdigest("--#{Time.now}--#{user.name}--")
user.encrypted_password = User.encrypt(user.password,user.salt)
user.role = 'contributor' 
user.save

user = User.new(name: 'susan', password: 'secret', password_confirmation: 'secret')
user.salt = Digest::SHA1.hexdigest("--#{Time.now}--#{user.name}--")
user.encrypted_password = User.encrypt(user.password,user.salt)
user.role = 'manager' 
user.save

user = User.new(name: 'yokota', password: 'secret', password_confirmation: 'secret')
user.salt = Digest::SHA1.hexdigest("--#{Time.now}--#{user.name}--")
user.encrypted_password = User.encrypt(user.password,user.salt)
user.role = 'manager' 
user.save




puts "Users `admin` and `contributor` have been created. Passwords are the same as the user names."

5.times do |i|
  Entry.create( term: "Term ##{i}", note: "Translator's note ##{i}", info: "Usage note ##{i}", approved: true )
end