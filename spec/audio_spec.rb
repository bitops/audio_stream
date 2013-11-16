require File.dirname(__FILE__) + '/../lib/audio_stream/audio'

describe MP3::Audio do
  
  it "should take the path to a file, where the audio section begins, a start time in millis, and an end time in millis and then read that many bytes using provided byterate" do
    audio = MP3::Audio.new('/path/to/file', 0)
    mock_io = mock("Mock::IO")
    audio.stub!(:prepare_audio_io).and_return(mock_io)
    mock_io.should_receive(:pos=).with(0)
    mock_io.should_receive(:read).with(20000).and_return(mock_io)
    audio.read_audio do |opts|
      opts.start_at = 0
      opts.stop_at = 1000
      opts.byterate = 20
    end
  end
  
  it "should use the number indicating where the audio section begins as an offset when setting the initial read position" do
    audio = MP3::Audio.new('/path/to/file', 30)
    mock_io = mock("Mock::IO")
    audio.stub!(:prepare_audio_io).and_return(mock_io)
    mock_io.should_receive(:pos=).with(10030)
    mock_io.should_receive(:read).with(10000).and_return(mock_io)
    audio.read_audio do |opts|
      opts.start_at = 500
      opts.stop_at = 1000
      opts.byterate = 20
    end
  end
  
  it "should require clients to populate the yielded options object when reading audio" do
    pending
  end
end