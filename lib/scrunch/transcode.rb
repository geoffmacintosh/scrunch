# The part that makes things smaller
module Transcode
  def self.crush_file(input_file, output_file)
    "afconvert \"#{input_file}\" -f m4bf -d aacp 32000 -o \"#{output_file}\""
  end
end
