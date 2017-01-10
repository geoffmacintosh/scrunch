# Everything reincoding. Compression and concatenation mostly.
module Transcode
  #  Compresses the file using afconvert. The output file is an He-AAC
  #  v2 file that is 32 kB/s.
  def self.crush_file(input_file, output_file)
    "afconvert \"#{input_file}\" -f m4bf -d aacp 32000 -o \"#{output_file}\""
  end
end
