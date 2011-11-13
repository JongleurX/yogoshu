class User < ActiveRecord::Base

  # unencrypted password
  attr_accessor :password

  def self.authenticate(name, pass)
    user = User.find_by_name(name)
  end

end
