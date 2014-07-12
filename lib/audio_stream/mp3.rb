require "rubygems"
require "mp3info"

require File.dirname(__FILE__) + "/audio"

module MP3
  class Base
    def self.open(file_name)
      self.new(file_name)
    end
    
    def initialize(file_name)
      @mp3_abs_path = file_name
      @bytes_per_second = 125
    end
    
    def close
      mp3info.close
    end
   
    def byterate
      millisecond_divisor = 1000
      byterate_in_seconds = kbps_conversion
      @byterate ||= byterate_in_seconds / millisecond_divisor
    end
    
    def length
      (mp3info.length * 1000).to_i
    end
    
    def bytes_from(start_time, end_time)
      grab_bytes(start_time, end_time)
    end
    
    def create_snippet_file(start_time, end_time)
      bytes = grab_bytes(start_time, end_time)
      path = path_to_save
      save_bytes_to_file_at_path(path, bytes)
      path
    end
    
    private
    def kbps_conversion
      bitrate * @bytes_per_second
    end
    
    def bitrate
      mp3info.bitrate
    end
    
    def grab_bytes(start_time, end_time)
      @audio ||= MP3::Audio.new(@mp3_abs_path, audio_pos)
      @audio.read_audio do |audio_options|
        audio_options.start_at = start_time
        audio_options.stop_at = end_time
        audio_options.byterate = byterate
      end
    end
    
    def path_to_save
      timestamp = Time.now.to_i
      filename = "#{timestamp}.mp3"
      "/tmp/#{filename}"
    end
    
    def save_bytes_to_file_at_path(path, bytes)
      File.open(path, "w") {|f| f << bytes}
    end
    
    def audio_pos
      mp3info.audio_content.first
    end
    
    def mp3info
      @mp3info ||= Mp3Info.open(@mp3_abs_path)
    end
  end
end
