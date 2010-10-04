require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

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

describe Gazette::Client, "#authenticate" do
  before(:each) do
    @client = Gazette::Client.new("foo")
  end
  
  describe "HTTP basic auth" do
    
    def mock_get_request
      @my_get = Net::HTTP::Get.new('/api/authenticate')
      Net::HTTP::Get.stub!(:new).and_return(@my_get)
    end
    
    before(:each) do
      mock_get_request
      stub_instapaper_api(:authenticate => {:status => 200})
    end
    
    it "passes along the username" do
      @my_get.should_receive(:basic_auth).with("foo", nil)
      @client.authenticate
    end
    
    it "passes along the password if specified" do
      @client = Gazette::Client.new("foo", :password => "bar")
      @my_get.should_receive(:basic_auth).with("foo", "bar")
      @client.authenticate
    end
  end
    
  describe "with a 200 OK response" do
    before(:each) do
      stub_instapaper_api(:authenticate => {:status => 200})
    end
    
    it "returns a Gazette::Response::Success object" do
      @client.authenticate.should be_a Gazette::Response::Success
    end
  end
  
  describe "with a 403 response" do
    before(:each) do
      stub_instapaper_api(:authenticate => {:status => 403})
    end
    
    it "rasises a Gazette::Response::InvalidCredentials" do
      lambda { 
        @client.authenticate 
      }.should raise_error(Gazette::Response::InvalidCredentials)
    end
  end
  
  describe "with a 500 response" do
    before(:each) do
      stub_instapaper_api(:authenticate => {:status => 500})
    end
    
    it "rasises a Gazette::Response::ServerError" do
      lambda { 
        @client.authenticate 
      }.should raise_error(Gazette::Response::ServerError)
    end
  end
  
  describe "with a XXX response" do
    before(:each) do
      stub_instapaper_api(:authenticate => {:status => 999})
    end
    
    it "rasises a Gazette::Response::UnknownError" do
      lambda { 
        @client.authenticate 
      }.should raise_error(Gazette::Response::UnknownError)
    end
  end

end