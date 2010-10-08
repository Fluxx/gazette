require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Gazette::Response::Success do
  before(:each) do
    @response = mock("response", :is_a? => true, :header => {})
  end
  
  it "raises an argument error unless the first argument is a Net::HTTPResponse object" do
    lambda do
      Gazette::Response::Success.new(:nonse)
    end.should raise_error(ArgumentError)
    
  end
  
  it "has a content_location attribute" do
    Gazette::Response::Success.new(@response).content_location.should be_nil
  end

  it "has an instapaper_title attribute" do
    Gazette::Response::Success.new(@response).instapaper_title.should be_nil
  end
  
  it "sets content_location if the 'Content-Location' header is present" do
    @response.stub!(:header).and_return({'Content-Location' => 'http://www.example.com/'})
    Gazette::Response::Success.new(@response).content_location.should == 'http://www.example.com/'
  end
  
  it "sets instapaper_title if the 'X-Instapaper-Title' header is present" do
    @response.stub!(:header).and_return({'X-Instapaper-Title' => 'nonse'})
    Gazette::Response::Success.new(@response).instapaper_title.should == 'nonse'
  end
    
end