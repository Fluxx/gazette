require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

INTERESTING_ARTICLE = "http://blog.instapaper.com/post/1256471940"

describe Gazette::Client, "#add" do
  before(:each) do
    @my_post = Net::HTTP::Post.new('/api/add')
    Net::HTTP::Post.stub!(:new).and_return(@my_post)
    @client = Gazette::Client.new("foo")
  end
  
  it "should raise an ArgumentError if no first argument is provided" do
    lambda do
      @client.add
    end.should raise_error(ArgumentError)
  end
  
  describe "parameters" do
    before(:each) do
      stub_instapaper_api(:add => {:status => 200})
    end
    
    it "passes the URL as a parameter" do
      @my_post.should_receive(:set_form_data).with(hash_including(:url => INTERESTING_ARTICLE))
      @client.add(INTERESTING_ARTICLE)
    end

    it "passes the title as a parameter if specified" do
      @my_post.should_receive(:set_form_data).with(hash_including(:title => "my title"))
      @client.add(INTERESTING_ARTICLE, :title => "my title")
    end

    it "passes the selection as a parameter if specified" do
      @my_post.should_receive(:set_form_data).with(hash_including(:selection => "read me!"))
      @client.add(INTERESTING_ARTICLE, :selection => "read me!")
    end
    
    it "passes redirect as a parameter if specified" do
      @my_post.should_receive(:set_form_data).with(hash_including(:redirect => :close))
      @client.add(INTERESTING_ARTICLE, :redirect => :close)
    end
    
  end
  
  describe "with a 200 OK response" do
    before(:each) do
      stub_instapaper_api(:add => {:status => 200})
    end
    
    it "returns a Gazette::Response::Success object" do
      @client.add(INTERESTING_ARTICLE).should be_a Gazette::Response::Success
    end
  end
  
  describe "with a 403 response" do
    before(:each) do
      stub_instapaper_api(:add => {:status => 403})
    end
    
    it "rasises a Gazette::Response::InvalidCredentials" do
      lambda { 
        @client.add(INTERESTING_ARTICLE)
      }.should raise_error(Gazette::Response::InvalidCredentials)
    end
  end
  
  describe "with a 500 response" do
    before(:each) do
      stub_instapaper_api(:add => {:status => 500})
    end
    
    it "rasises a Gazette::Response::ServerError" do
      lambda { 
        @client.add(INTERESTING_ARTICLE)
      }.should raise_error(Gazette::Response::ServerError)
    end
  end
  
  describe "with a XXX response" do
    before(:each) do
      stub_instapaper_api(:add => {:status => 999})
    end
    
    it "rasises a Gazette::Response::UnknownError" do
      lambda { 
        @client.add(INTERESTING_ARTICLE)
      }.should raise_error(Gazette::Response::UnknownError)
    end
  end
  
end