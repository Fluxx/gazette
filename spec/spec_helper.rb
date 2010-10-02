$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'gazette'
require 'spec'
require 'spec/autorun'
require 'fakeweb'

Spec::Runner.configure do |config|

end

# Stubs out the instapaper API using a simple configuration syntax:
# 
# :method => {:hash_of => :fakeweb_options}
def stub_instapaper_api(configuration)
  configuration.each do |method, opts|
    FakeWeb.register_uri(:any, Gazette::Client::ENDPOINT+method.to_s, opts)
  end
end