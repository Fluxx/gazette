require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Gazette::Client, "#add" do
  subject { Gazette::Client.new("foo") }
  let(:my_post) { Net::HTTP::Post.new('/api/add') }
  let(:interesting_article) { "http://blog.instapaper.com/post/1256471940" }

  before(:each) do
    post = my_post # Pull instance before overwriting constructor
    Net::HTTP::Post.stub!(:new).and_return(post)
  end
  
  it "should raise an ArgumentError if no first argument is provided" do
    lambda do
      subject.add
    end.should raise_error(ArgumentError)
  end
  
  describe "with a 201 OK response" do
    before(:each) do
      stub_instapaper_api(:add => {:status => 201})
    end
    
    it "returns a Gazette::Response::Success object" do
      subject.add(interesting_article).should be_a Gazette::Response::Success
    end
    
    it "calls the add instapaper API call" do
      Net::HTTP::Post.should_receive(:new).with(/add/).and_return(my_post)
      subject.add(interesting_article)
    end

    describe "parameters" do

      it "passes the URL as a parameter" do
        my_post.should_receive(:set_form_data).with(hash_including(:url => interesting_article))
        subject.add(interesting_article)
      end

      it "passes the title as a parameter if specified" do
        my_post.should_receive(:set_form_data).with(hash_including(:title => "my title"))
        subject.add(interesting_article, :title => "my title")
      end

      it "passes the selection as a parameter if specified" do
        my_post.should_receive(:set_form_data).with(hash_including(:selection => "read me!"))
        subject.add(interesting_article, :selection => "read me!")
      end

      it "passes redirect as a parameter if specified" do
        my_post.should_receive(:set_form_data).with(hash_including(:redirect => :close))
        subject.add(interesting_article, :redirect => :close)
      end

      it "passes the jsonp as a parameter if specified" do
        my_post.should_receive(:set_form_data).with(hash_including(:jsonp => "myfunc"))
        subject.add(interesting_article, :jsonp => "myfunc")
      end

    end
  end
  
  describe "with a 403 response" do
    before(:each) do
      stub_instapaper_api(:add => {:status => 403})
    end
    
    it "rasises a Gazette::Response::InvalidCredentials" do
      lambda { 
        subject.add(interesting_article)
      }.should raise_error(Gazette::Response::InvalidCredentials)
    end
  end
  
  describe "with a 500 response" do
    before(:each) do
      stub_instapaper_api(:add => {:status => 500})
    end
    
    it "rasises a Gazette::Response::ServerError" do
      lambda { 
        subject.add(interesting_article)
      }.should raise_error(Gazette::Response::ServerError)
    end
  end
  
  describe "with a XXX response" do
    before(:each) do
      stub_instapaper_api(:add => {:status => 999})
    end
    
    it "rasises a Gazette::Response::UnknownError" do
      lambda { 
        subject.add(interesting_article)
      }.should raise_error(Gazette::Response::UnknownError)
    end
  end
  
end