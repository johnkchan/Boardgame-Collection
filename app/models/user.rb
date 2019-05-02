class User < ActiveRecord::Base
  has_many :boardgames
  validates_presence_of :username, :email, :password
  has_secure_password

  def slug
    self.username.downcase.gsub(" ", "-")
  end

  def self.find_by_slug(slug)
    all.find{|item| item.slug == slug}
  end
end