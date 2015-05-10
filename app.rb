# Require the bundler gem and then call Bundler.require to load in all gems
# listed in Gemfile.
require 'bundler'
Bundler.require

root = File.expand_path File.dirname(__FILE__)

require_relative 'models/company'
require_relative 'models/director'

Rabl.configure do |config|
  config.include_json_root = false
  config.include_child_root = false
end

require 'rack/cors'

use Rack::Cors do |config|
  config.allow do |allow|
    allow.origins '*'
    allow.resource '*',
      :headers => :any,
      :methods => [:get, :post, :delete, :put, :options],
      :max_age => 0
  end
end




# Setup DataMapper with a database URL. On Heroku, ENV['DATABASE_URL'] will be
# set, when working locally this line will fall back to using SQLite in the
# current directory.
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/development.sqlite")

# Finalize the DataMapper models.
DataMapper.finalize

# Tell DataMapper to update the database according to the definitions above.
DataMapper.auto_upgrade!


namespace '/api/v:version' do

  get '/companies' do
    content_type :json
    @companies = Company.all(:order => :created_at.desc)
    Rabl::Renderer.json(@companies, 'company', view_path: './views')
  end



  # CREATE: Route to create a new Company
  post '/companies' do
    content_type :json
    @company = Company.new({
       name: params[:name],
       address: params[:address],
       country: params[:country],
       email: params[:email],
       phone: params[:phone],
       city: params[:city]
     })
    if @company.save
      Rabl::Renderer.json(@company, 'company', view_path: './views')
      # @company.to_json
    else
      halt 500
    end
  end


  # READ: Route to show a specific Company based on its `id`
  get '/companies/:id' do
    content_type :json
    @company = Company.get(params[:id].to_i)

    if @company
      Rabl::Renderer.json(@company, 'company', view_path: './views')
    else
      halt 404
    end
  end

  # UPDATE: Route to update a Company
  put '/companies/:id' do
    content_type :json
    @company = Company.get(params[:id].to_i)
    @company.update({
       name: params[:name],
       address: params[:address],
       country: params[:country],
       email: params[:email],
       phone: params[:phone],
       city: params[:city]
     })

    if @company.save
      @company.to_json
    else
      halt 500
    end
  end

  # DELETE: Route to delete a Company
  delete '/companies/:id' do

    content_type :json
    @company = Company.get(params[:id].to_i)

    if @company.destroy
      {:success => "ok"}.to_json
    else
      halt 500
    end
  end

end

# If there are no Companys in the database, add a few.
if Company.count == 0
  Company.create(:name => "Test Company One", :email => "lal@lal.com")
  Company.create(:name => "Test Company Two", :email => "lal@lal.com")
end
