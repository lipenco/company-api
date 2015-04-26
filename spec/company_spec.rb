require File.expand_path '../spec_helper.rb', __FILE__

describe "Company" do

  def app
    Sinatra::Application
  end

  let(:company) {
    Company.new(name: "company1",
                country: "country1",
                address: "address1",
                email: "email1",
                city: "city1",
                phone: "phone1")

  }


  it "should all companies" do
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

  it "it shows one coompany" do
    company.save!
    get "/api/v1/companies/#{company.id}"
    expect(last_response).to be_ok
    expect(last_response.body).to eq(Company.last.to_json)
  end

  it "it deletes company" do
    company.save!
    company.destroy
    get "/api/v1/companies/#{company.id}"
    expect(last_response.body).to eq("")
  end

end
