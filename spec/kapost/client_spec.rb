require 'spec_helper'

describe Kapost::Client do

  context "object initialization" do
    it "creates an object if required parameters are passed" do
      expect(Kapost::Client.new(:api_token => "XXX", :instance => "foo")).to be_an_instance_of(Kapost::Client)
    end

    it "raises an error if required parameters are missing" do
      expect { Kapost::Client.new }.to raise_error(ArgumentError)
    end
  end

  context "Private Methods" do

    before(:each) do
      Kapost.configure do |config|
        config.api_token = "foo"
        config.instance  = "bar"
      end

      @client = Kapost::Client.new
      @http_200 = double('net http response', :to_hash => {"Status" => ["200 OK"]}, :code => 200)
      @http_204 = double('net http response', :to_hash => {"Status" => ["204 No Content"]}, :code => 200)

      @general_response = File.open(File.expand_path("../../fixtures/client/get.json", __FILE__), 'rb') {|io| io.read}

      stub_request(:get, "https://foo:@bar.kapost.com/api/v1/content/lebowski?id=lebowski")
        .to_return(:status => 200, :body => @general_response, :headers => {})
      stub_request(:post, "https://foo:@bar.kapost.com/api/v1/content")
        .with(:body => {"title"=>"Maude"})
        .to_return(:status => 200, :body => @general_response, :headers => {})
      stub_request(:put, "https://foo:@bar.kapost.com/api/v1/content/lebowski")
        .with(:body => {"title"=>"Maude", "id"=>"lebowski"})
        .to_return(:status => 201, :body => @general_response, :headers => {})
      stub_request(:delete, "https://foo:@bar.kapost.com/api/v1/content/lebowski?id=lebowski")
        .to_return(:status => 204, :body => "", :headers => {})
    end

    after(:each) do
      Kapost.apply_config
    end

    context "HTTP Operations" do
      it "performs a GET request" do
        path   = 'content/lebowski'
        params = {:id => 'lebowski'}

        expect(@client.send(:get, path, params)).to be_truthy
      end

      it "performs a POST request" do
        path   = 'content'
        params = {:title => 'Maude'}

        expect(@client.send(:post, path, params)).to be_truthy
      end

      it "performs a PUT request" do
        path   = 'content/lebowski'
        params = {:id => 'lebowski', :title => 'Maude'}

        expect(@client.send(:put, path, params)).to be_truthy
      end

      it "performas a DELETE request" do
        path   = 'content/lebowski'
        params = {:id => 'lebowski'}

        expect(@client.send(:delete, path, params)).to be_truthy
      end
    end

    context "Response parsing" do

      it "parses the response for successful GET and POST operations" do
        response = ::RestClient::Response.create(@general_response, @http_200, {})

        expect(@client.send(:parse_response, response)).to be_truthy
      end

      it "returns true upon successful deletion" do
        response = ::RestClient::Response.create(@general_response, @http_204, {})

        expect(@client.send(:parse_response, response)).to be_truthy
      end
    end
  end

end