class Cook < ActiveRecord::Base
  EMAIL_PATTERN = /^([a-z0-9]+[-\._]?)+[a-z0-9]+@([a-z0-9]+[-\._]?)+[a-z0-9]+\.[a-z]{2,8}$/ui
  USERNAME_PATTERN = /^[a-z0-9]+$/i
  AUTH_KEY_PATTERN = /^[a-z0-9\$\*\-_%]{40}$/i
  
  has_many :cookbooks
  has_many :recipes
  
  has_secure_password
  
  attr_accessible :username, :email, :password, :password_confirmation
  
  validates_presence_of   :email, :username
  validates_uniqueness_of :email, :username
  validates_format_of     :email, with: EMAIL_PATTERN, message: "Invalid email address."

  before_validation :set_auth_key, on: :create

  validates_format_of     :username,  with: USERNAME_PATTERN, message: "Username can only contain alphanumeric characters."
  validates_length_of     :username,  minimum: 7, maximum: 32
  
  validates_presence_of		:auth_key
	validates_format_of			:auth_key, with: AUTH_KEY_PATTERN
	
	class <<self
		
		def generate_auth_key(length=40)
		  chars = ("a".."z").to_a + ("0".."9").to_a + %w($ * - _ %)
		  
      auth_key = Array.new(length).map { chars[rand(chars.length)].send([:upcase,:downcase][rand(2)]) }.join
      while Cook.exists?(auth_key: auth_key) do
        auth_key = generate_auth_key
      end
      auth_key
	  end
		
	end
	
	private
  
  def set_auth_key
    self.auth_key = self.class.generate_auth_key
  end
end
