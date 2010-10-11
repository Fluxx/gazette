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
      @client.username.should eql("foo")
    end
  end

  describe "with a single string argument" do
    before(:each) do
      @client = Gazette::Client.new("foo")
    end

    it_should_behave_like "a properlty constructed client"

    it "has no password set" do
      @client.password.should be_nil
    end

  end

  describe "with a string and hash containing a :password" do
    before(:each) do
      @client = Gazette::Client.new("foo", :password => "bar")
    end

    it_should_behave_like "a properlty constructed client"

    it "has a password set" do
      @client.password.should eql("bar")
    end

  end
  
end

describe Gazette::Client, "HTTP basic auth" do
  before(:each) do
    stub_instapaper_api(:authenticate => {:status => 200})
    @client = Gazette::Client.new("foo")
    @my_post = Net::HTTP::Post.new('/api/authenticate')
    Net::HTTP::Post.stub!(:new).and_return(@my_post)
  end  
  
  it "passes along the username" do
    @my_post.should_receive(:basic_auth).with("foo", nil)
    @client.authenticate
  end
  
  it "passes along the password if specified" do
    @client = Gazette::Client.new("foo", :password => "bar")
    @my_post.should_receive(:basic_auth).with("foo", "bar")
    @client.authenticate
  end
  
  it "passes the jsonp as a parameter if specified" do
    @my_post.should_receive(:set_form_data).with(hash_including(:jsonp => "myfunc"))
    @client.authenticate(:jsonp => "myfunc")
  end
end

describe Gazette::Client, "over HTTPS" do
  @client = Gazette::Client.new("foo", :https => true)
  stub_instapaper_api(:authenticate => {:status => 200})
end