require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Gazette::Client, ".new" do

  it "raises an error if no fist argument it passed" do
    lambda { Gazette::Client.new }.should raise_error(ArgumentError)
  end
  
  it "raises an argument error if the 2nd parameter is not a hash" do
    lambda { Gazette::Client.new("foo", 56) }.should raise_error(ArgumentError)
  end

  shared_examples_for "a properlty constructed client" do
    it "sets the username as the first argument" do
      subject.username.should eql("foo")
    end
  end

  describe "with a single string argument" do
    subject { Gazette::Client.new("foo") }

    it_should_behave_like "a properlty constructed client"

    it "has no password set" do
      subject.password.should be_nil
    end

  end

  describe "with a string and hash containing a :password" do
    subject { Gazette::Client.new("foo", :password => "bar") }

    it_should_behave_like "a properlty constructed client"

    it "has a password set" do
      subject.password.should eql("bar")
    end

  end
  
end

describe Gazette::Client, "HTTP basic auth" do
  subject { Gazette::Client.new("foo") }
  let(:my_post) { Net::HTTP::Post.new('/api/authenticate') }
  
  before(:each) do
    stub_instapaper_api(:authenticate => {:status => 200})
    post = my_post # Pull instance before overwriting constructor
    Net::HTTP::Post.stub!(:new).and_return(post)
  end  
  
  it "passes along the username" do
    my_post.should_receive(:basic_auth).with("foo", nil)
    subject.authenticate
  end
  
  it "passes along the password if specified" do
    subject = Gazette::Client.new("foo", :password => "bar")
    my_post.should_receive(:basic_auth).with("foo", "bar")
    subject.authenticate
  end
  
  it "passes the jsonp as a parameter if specified" do
    my_post.should_receive(:set_form_data).with(hash_including(:jsonp => "myfunc"))
    subject.authenticate(:jsonp => "myfunc")
  end
end

describe Gazette::Client, "over HTTPS" do
  subject { Gazette::Client.new("foo", :https => true) }
  let(:my_http) { Net::HTTP.new(Gazette::Api::ADDRESS, 443) }
  
  before(:each) do
    stub_instapaper_api(:authenticate => {:status => 200})
  end
  
  it "tells the HTTP client to use ssl" do
    http = my_http # Pull instance before overwriting constructor
    Net::HTTP.should_receive(:new).with(anything, 443).and_return(http)
    subject.authenticate
  end
  
end