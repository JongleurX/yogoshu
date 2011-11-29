class User < ActiveRecord::Base

  # unencrypted password
  attr_accessor :password

  ROLES = %w[manager contributor]

  # associations
  has_many :entries

  # sexy validation
  validates :name, :uniqueness => { :message => "has already been taken." }, :presence => true
  validates :password, :confirmation => true, :length => { :minimum => 4 }, :if => :password_required?
  validates :password_confirmation, :presence => true, :if => :password_required?
  validates :role, :presence => true, :inclusion => { :in => (0..(ROLES.length-1)), :message => "Not a valid role." }

  # encrypt password
  before_save :encrypt_password

  def to_param
    name
  end

  def role_string
    (0..ROLES.length) === role ? ROLES[role] : nil
  end

  def self.authenticate(name, pass)
    user = User.find_by_name(name)
  end

  def self.current_user=(user)
    Thread.current[:yogoshu_current_user] = user
  end

  def self.current_user
    Thread.current[:yogoshu_current_user]
  end

  # encrypts given password using salt
  def self.encrypt(pass, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{pass}--")
  end

   # does the given password match the stored encrypted password
  def authenticated?(pass)
    encrypted_password == User.encrypt(pass, salt)
  end
 
  protected

  def encrypt_password
    return if password.blank?
    if new_record?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now}--#{name}--")
    end
    self.encrypted_password = User.encrypt(password, salt)
  end

  #   no encrypted password yet OR password attribute is set
  def password_required?
    encrypted_password.blank? || !password.blank?
  end  

end
