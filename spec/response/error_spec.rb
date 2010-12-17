require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Gazette::Response::Error do

  it "is the superclass of InvalidCredentials, ServerError and UnknownError errors" do
    Gazette::Response::InvalidCredentials.superclass.should == Gazette::Response::Error
    Gazette::Response::ServerError.superclass.should == Gazette::Response::Error
    Gazette::Response::UnknownError.superclass.should == Gazette::Response::Error
  end
  
  it "is a subclass of StandardError" do
    Gazette::Response::Error.superclass.should == StandardError
  end
  
end