$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'gazette'
require 'fakeweb'
require 'rspec'

RSpec.configure do |config|
  config.color_enabled = true
end

# Stubs out the instapaper API using a simple configuration syntax:
# 
# :method => {:hash_of => :fakeweb_options}
def stub_instapaper_api(configuration)
  configuration.each do |method, opts|
    ["", "foo@", "foo:bar@"].each do |hba|
      base = "#{hba}#{Gazette::Api::ADDRESS}#{Gazette::Api::ENDPOINT}"
      FakeWeb.register_uri(:any, "http://"+base+method.to_s, opts.merge(:body => "lol"))
      FakeWeb.register_uri(:any, "https://"+base+method.to_s, opts)
    end
  end
end