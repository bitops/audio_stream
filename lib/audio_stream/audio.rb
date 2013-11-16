module MP3
  class Audio
    def initialize(file_path, audio_start_pos)
      @file_path = file_path
      @audio_start_pos = audio_start_pos
    end
    
    def read_audio
      io = prepare_audio_io
      yield(options)
      io.pos = beginning_marker
      io.read(bytes_to_read)
    end
    
    private
    def bytes_to_read
      @bytes_to_read = ending_marker * options.byterate
    end
    
    def ending_marker
      @end = options.stop_at - options.start_at
    end
    
    def beginning_marker
      @begin = (options.start_at * options.byterate) + @audio_start_pos
    end
    
    def prepare_audio_io
      f = File.open(@file_path, 'r')
      io = IO.new(f.to_i)
    end
    
    def options
      @opts ||= MP3::AudioOptions.new
    end
  end  
  
  class AudioOptions
    attr_accessor :start_at, :stop_at, :byterate
  end
end

