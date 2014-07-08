require 'spec_helper'

describe Kapost::Content do

  before(:each) do

    Kapost.configure do |config|
      config.api_token = "foo"
      config.instance  = "bar"
    end

    @client = Kapost::Client.new()

    show_basic = File.open(File.expand_path("../../fixtures/content/show_basic.json", __FILE__), 'rb') {|io| io.read}
    show_full  = File.open(File.expand_path("../../fixtures/content/show_full.json", __FILE__), 'rb') {|io| io.read}
    create     = File.open(File.expand_path("../../fixtures/content/create.json", __FILE__), 'rb') {|io| io.read}
    update     = File.open(File.expand_path("../../fixtures/content/update.json", __FILE__), 'rb') {|io| io.read}
    list_basic = File.open(File.expand_path("../../fixtures/content/list_basic.json", __FILE__), 'rb') {|io| io.read}

    stub_request(:get, /https:\/\/foo:@bar.kapost.com\/api\/v1\/content\/lebowski?.*detail=basic.*/)
      .to_return(:body => show_basic, :status => 200, :headers => {})
    stub_request(:get, /https:\/\/foo:@bar.kapost.com\/api\/v1\/content\/lebowski?.*detail=full.*/)
      .to_return(:body => show_full, :status => 200, :headers => {})
    stub_request(:post, "https://foo:@bar.kapost.com/api/v1/content")
      .with(:body => {"title"=>"It really tied the room together", "content_type_id"=>"11111111"})
      .to_return(:body => create, :status => 201, :headers => {})
    stub_request(:put, "https://foo:@bar.kapost.com/api/v1/content/lebowski")
      .with(:body => {"title"=>"This will not stand, man", "content_type_id"=>"11111111", "id"=>"lebowski"})
      .to_return(:body => update, :status => 200, :headers => {})
    stub_request(:delete, "https://foo:@bar.kapost.com/api/v1/content/lebowski?id=lebowski")
      .to_return(:status => 204, :body => "", :headers => {})
    stub_request(:get, "https://foo:@bar.kapost.com/api/v1/content?page=1&per_page=2")
      .to_return(:status => 200, :body => list_basic, :headers => {})
  end

  after(:each) do
    Kapost.apply_config
  end

  context "Listing Content" do

    it "gets a list of content" do
      response = @client.list_content(:per_page => 2, :page => 1)
      expect(response.count).to eq(2)
    end

  end

  context "Creating Content" do

    it "creates content when required parameters are passed" do
      response = @client.create_content(:title => "It really tied the room together", :content_type_id => '11111111')
      expect(response[:title]).to match(/It really tied the room together/)
    end

    it "returns an error if required parameters are not passed" do
      expect { @client.create_content }.to raise_error(ArgumentError)
    end

    it "returns false if invalid parameters are passed" do
      expect(@client.show_content({:fake_param => 'lebowski'})).to be_falsey
    end

  end

  context "Showing Content" do
    it "shows content when required parameters are passed" do
      response = @client.show_content({:id => 'lebowski', :detail => 'full'})
      expect(response[:title]).to be_truthy
    end

    it "returns an error if required parameters are not passed" do
      expect { @client.show_content }.to raise_error(ArgumentError)
    end

    it "returns false if invalid parameters are passed" do
      expect(@client.show_content({:id => 'lebowski', :fake_param => 'lebowski'})).to be_falsey
    end
  end

  context "Updating Content" do
    it "updates content when required parameters are passed" do
      response = @client.update_content(:id => 'lebowski', :title => "This will not stand, man", :content_type_id => '11111111')
      expect(response[:title]).to match(/This will not stand, man/)
    end

    it "returns an error if required parameters are not passed" do
      expect { @client.update_content }.to raise_error(ArgumentError)
    end

    it "returns an error if invalid parameters are passed" do
      expect(@client.update_content({:fake_param => 'lebowski'})).to be_falsey
    end
  end

  context "Deleting Content" do
    it "deletes content when required parameters are passed" do
      expect(@client.delete_content({:id => 'lebowski'})).to be_truthy
    end

    it "returns an error if required parameters are not passed" do
      expect { @client.delete_content }.to raise_error(ArgumentError)
    end

    it "returns false if invalid parameters are passed" do
      expect(@client.delete_content({:fake_param => 'lebowski'})).to be_falsey
    end
  end

end