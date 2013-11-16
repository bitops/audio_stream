require File.dirname(__FILE__) + '/../lib/audio_stream/mp3'

describe MP3 do
  before :each do
    @mp3 = MP3::Base.open('/some/fs/path/excellent.mp3')    
    @bytes_per_second = 125
  end
  
  after :each do
    # Mainly here for illustration purposes of correct usage
    @mp3.stub!(:close)
    @mp3.close
  end
  
  context "creation" do
    it "should require clients to open and close the object" do
      mp3 = MP3::Base.open('/some/fs/path/excellent.mp3')
      mock_mp3info = mock("Mp3Info")
      mp3.stub!(:mp3info).and_return(mock_mp3info)
      mock_mp3info.should_receive(:close)
      mp3.class.should be(MP3::Base)
      mp3.close
    end
  end
  
  context "primitive" do
    it "should know the raw mp3's length in milliseconds" do
      mock_mp3info = mock("Mp3Info")
      @mp3.stub!(:mp3info).and_return(mock_mp3info)
      mock_mp3info.should_receive(:length).and_return(10.5)
      @mp3.length.should be(10500)
    end
  end
  
  context "byterate" do
    it "should know the mp3's 'byterate' - the number of bytes per millisecond" do
      bitrate = 160
      @mp3.should_receive(:bitrate).once.and_return(bitrate)
      byterate_in_millis = (bitrate * @bytes_per_second) / 1000
      @mp3.byterate.should be(byterate_in_millis)
    end
    
    it "should calculate the byterate by multiplying 125 by the bitrate, doing a kbps conversion" do
      bitrate = 128
      @mp3.should_receive(:bitrate).and_return(bitrate)
      expected_byterate = (bitrate * @bytes_per_second) / 1000
      @mp3.byterate.should be(expected_byterate)
    end
  end

  context "audio snippet" do 
      it "should write the read bytes to a file, returning the path to the written file" do
        mp3 = MP3::Base.open('/some/fs/path/excellent.mp3')
        bytes = "bytestream"
        mp3.should_receive(:grab_bytes).with(0, 1000).and_return(bytes)
        filename = "/tmp/saved.mp3"
        mp3.stub!(:path_to_save).and_return(filename)
        mp3.should_receive(:save_bytes_to_file_at_path).with(filename, bytes)
        mp3.create_snippet_file(0, 1000).should == filename
      end
      
      it "should provide the raw bytes" do
        mp3 = MP3::Base.open('/some/fs/path/excellent.mp3')
        bytes = "bytestream"
        mp3.should_receive(:grab_bytes).with(0, 1000).and_return(bytes)
        mp3.bytes_from(0, 1000).should == bytes
      end
      
      it "should tag the byte snippet with correct length" do
        pending
      end
  end
end