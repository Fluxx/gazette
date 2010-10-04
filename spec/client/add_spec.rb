require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Gazette::Client, "#add" do
  before(:each) do
    @client = Gazette::Client.new("foo")
  end
  
  it "should raise an ArgumentError if no first argument is provided"
  it "should pass the URL as a parameter"
  it "should pass the title as a parameter if specified"
  it "should pass the selection as a parameter if specified"
  it "should pass redirect as a parameter if specified"

  it "should return a Response::Success object on a 201"
  it "should return raise Response::BadRequest object on 400"
  it "should return raise Response::ServerError object on 500"
  it "should return raise Response::UnknownError object on XXX"
end