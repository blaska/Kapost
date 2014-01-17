# Kapost

Simple Ruby wrapper for the Kapost API version 1

## Installation

Add this line to your application's Gemfile:

    gem 'kapost'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install kapost

## Usage

### Configuration and Client Instantiation

Common usage:

    require 'kapost'

    Kapost.configure do |config|
      config.api_token = ENV['KAPOST_API_KEY']
      config.instance  = ENV['KAPOST_INSTANCE']
    end

    client = Kapost::Client.new

Alternatively:

    require 'kapost'

    client = Kapost::Client.new(:api_token => ENV['KAPOST_API_KEY'], :instance => ENV['KAPOST_INSTANCE'])

### Showing content

    client.show_content(:id => 'the_dude_abides_1')
    # => {...}

### Creating Content

    params = { ... }
    client.create_content(params)
    # => {...}

### Updating Content

    params = { ... }
    client.update_content(params)
    # => {...}

### Deleting Content

    client.delete_content(:id => 'out_of_your_element_1')
    # => {...}

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes including rspec tests (`git commit -am 'Add some feature'`) - Note: Please do not change the version number
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
