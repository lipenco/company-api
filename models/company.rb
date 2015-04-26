

class Company
  include DataMapper::Resource

  property :id, Serial, :key => true
  property :created_at, DateTime
  property :name, String, :length => 255
  property :address, String, :length => 255
  property :city, String, :length => 255
  property :country, String, :length => 255
  property :email, String, :length => 255
  property :phone, String, :length => 255

  has n, :directors

  validates_presence_of :name, :address, :city, :country




end
