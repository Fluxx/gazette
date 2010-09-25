require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Gazette::Client, ".new" do
    
  it "raises an error if no fist argument it passed" do
    lambda { Gazette::Client.new }.should raise_error(ArgumentError)
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
