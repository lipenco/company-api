
class Director
  include DataMapper::Resource

  property :id, Serial, :key => true
  property :created_at, DateTime
  property :name, String, :length => 255
  property :surname, String, :length => 255
  property :passport_pdf_url, String, :length => 255

  belongs_to :company

end
