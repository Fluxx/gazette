require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Gazette::Client, "#authenticate" do
  subject { Gazette::Client.new("foo") }
  let(:my_post) { Net::HTTP::Post.new('/api/authenticate') }
    
  describe "with a 200 OK response" do
    before(:each) do
      stub_instapaper_api(:authenticate => {:status => 200})
    end
    
    it "returns a Gazette::Response::Success object" do
      subject.authenticate.should be_a Gazette::Response::Success
    end
    
    it "calls the 'authenticate' instapaper API call" do
      post = my_post # Pull instance before overwriting constructor
      Net::HTTP::Post.should_receive(:new).with(/authenticate/).and_return(post)
      subject.authenticate
    end
  end
  
  describe "with a 403 response" do
    before(:each) do
      stub_instapaper_api(:authenticate => {:status => 403})
    end
    
    it "rasises a Gazette::Response::InvalidCredentials" do
      lambda { 
        subject.authenticate 
      }.should raise_error(Gazette::Response::InvalidCredentials)
    end
  end
  
  describe "with a 500 response" do
    before(:each) do
      stub_instapaper_api(:authenticate => {:status => 500})
    end
    
    it "rasises a Gazette::Response::ServerError" do
      lambda { 
        subject.authenticate 
      }.should raise_error(Gazette::Response::ServerError)
    end
  end
  
  describe "with a XXX response" do
    before(:each) do
      stub_instapaper_api(:authenticate => {:status => 999})
    end
    
    it "rasises a Gazette::Response::UnknownError" do
      lambda { 
        subject.authenticate 
      }.should raise_error(Gazette::Response::UnknownError)
    end
  end

end