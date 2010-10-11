require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Gazette::Client, "#authenticate" do
  before(:each) do
    @client = Gazette::Client.new("foo")
    @my_post = stub_http_client('/api/authenticate')
  end
    
  describe "with a 200 OK response" do
    before(:each) do
      stub_instapaper_api(:authenticate => {:status => 200})
    end
    
    it "returns a Gazette::Response::Success object" do
      @client.authenticate.should be_a Gazette::Response::Success
    end
    
    it "calls the 'authenticate' instapaper API call" do
      Net::HTTP::Post.should_receive(:new).with(/authenticate/).and_return(@my_post)
      @client.authenticate
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