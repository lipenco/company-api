object @company
attributes :id, :name, :address, :city, :country, :email, :phone
child :directors do
  attributes :id, :name, :surname, :pdf
end
