require 'spec_helper'

describe Kapost::Configuration do

  context "accessors" do
    it "returns a default domain" do
      expect(Kapost.domain).to eq(Kapost::Configuration::DEFAULT_DOMAIN)
    end

    it "returns a default api_token" do
      expect(Kapost.api_token).to eq(Kapost::Configuration::DEFAULT_API_TOKEN)
    end

    it "returns a default api_version" do
      expect(Kapost.api_version).to eq(Kapost::Configuration::DEFAULT_API_VERSION)
    end

    it "returns a default api_path" do
      expect(Kapost.api_path).to eq(Kapost::Configuration::DEFAULT_API_PATH)
    end

    it "returns a default instance" do
      expect(Kapost.instance).to eq(Kapost::Configuration::DEFAULT_INSTANCE)
    end

    it "returns a default format" do
      expect(Kapost.format).to eq(Kapost::Configuration::DEFAULT_FORMAT)
    end

    it "returns a default user_agent" do
      expect(Kapost.user_agent).to eq(Kapost::Configuration::DEFAULT_USER_AGENT)
    end
  end

  context ".configure method" do
    after do
      Kapost.apply_config
    end

    Kapost::Configuration::VALID_PARAMS.each do |key|
      it "sets the key #{key}" do
        Kapost.configure do |config|
          config.send("#{key}=", key)
          expect(Kapost.send(key)).to eq(key)
        end
      end
    end
  end

  context ".options method" do
    it "returns a hash of default options" do
      options = Kapost.options
      keys    = options.keys

      expect(options).to be_an_instance_of(Hash)
      expect(keys).to eq(Kapost::Configuration::VALID_PARAMS)
    end
  end

end