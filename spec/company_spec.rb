require File.expand_path '../spec_helper.rb', __FILE__

describe "Company" do

  def app
    Sinatra::Application
  end

  def response_body
    JSON.parse(last_response.body)
  end

  let(:company) {
    Company.new(name: "company1",
                country: "country1",
                address: "address1",
                email: "email1",
                city: "city1",
                phone: "phone1")

  }

  let(:director) {
    Director.new(name: "boss_nam1",
                 surname: "boss_surname1")

  }

  let(:director2) {
    Director.new(name: "boss_nam1",
                 surname: "boss_surname1")

  }


  it "should show all companies" do
    get '/api/v1/companies'
    expect(last_response).to be_ok
  end

  it "saves attributes" do
    company.save!
    expect(company).to be_valid
    expect(Company.last.name).to eq("company1")
    expect(Company.last.phone).to eq("phone1")
  end

  it "updates attributes" do
    company.save!
    company.update(country: "country2")
    expect(Company.last.name).to eq("company1")
    expect(Company.last.country).to eq("country2")
  end

  it "shows one coompany" do
    company.save!
    get "/api/v1/companies/#{company.id}"
    expect(last_response).to be_ok
    expect(response_body["name"]).to eq(Company.last.name)
  end

  it "deletes company" do
    company.save!
    company.destroy
    get "/api/v1/companies/#{company.id}"
    expect(last_response.body).to eq("")
  end

  it "validates presence of name, city, coutry" do
    company.name = ""
    company.save
    get "/api/v1/companies/#{company.id}"
    expect(last_response).to_not be_ok
  end

  it "saves model instance without email" do
    company.email = ""
    company.save
    get "/api/v1/companies/#{company.id}"
    expect(response_body["name"]).to eq(Company.last.name)
    expect(response_body["email"]).to eq("")
  end

  it "has many directors" do
    company.directors.push(director)
    company.directors.push(director2)
    company.save
    expect(company.directors.size).to eq(2)
    expect(Director.last).to eq(director2)
  end

  it "has directors in json" do
    company.directors.push(director)
    company.directors.push(director2)
    company.save
    get "/api/v1/companies/#{company.id}"
    expect(response_body["directors"].size).to eq(2)
  end

end
