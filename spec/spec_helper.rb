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
    ["", "foo", "foo:bar"].each do |hba|
      base = "http://#{hba}@#{Gazette::Api::ADDRESS}#{Gazette::Api::ENDPOINT}"
      FakeWeb.register_uri(:any, base+method.to_s, opts)
    end
  end
end

# Stubs out the HTTP client and builds a @my_post variable, which is our own mock we can
# use to verify HTTP actions
def stub_http_client(path)
  @my_post = Net::HTTP::Post.new(path)
  Net::HTTP::Post.stub!(:new).and_return(@my_post)
  @my_post
end