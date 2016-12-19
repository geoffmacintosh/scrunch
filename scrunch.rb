# -*-Ruby-*-

def get_metadata(input_file)
  unprocessed = `AtomicParsley \"#{input_file}\" -t`
  array_lines = unprocessed.split(/\n/)
  array_complicated = []
  array_lines.each { |i|
    array_complicated << i.split(": ")
  }
  array_transposed = array_complicated.transpose
  array_transposed[0].map! { |i|
    /[\w]{3,4}(?=\" contains)/.match(i).to_s
  }
  Hash[array_transposed[0].zip(array_transposed[1])]
end

def get_cover(input_file)
  unprocessed = `AtomicParsley \"#{input_file}\" -E`
  /(?<=\: ).*/.match(unprocessed).to_s
end

def crush_file(input_file, output_file)
  "afconvert \"#{input_file}\" -f m4bf -d aacp 32000 -o \"#{output_file}\""
end

def make_filename(input_file, metadata)
  if /\,.*\([0-9]{4}\)/.match(input_file)
   /.*(?=\.[mM]4[aAbB])/.match(input_file).to_s + "-new.m4b"
  else
    "#{metadata["ART"]} #{metadata["nam"]}.m4b"
  end
end

def apply_metadata(input_file, metadata, cover_path)
  "AtomicParsley \"#{input_file}\" --title \"#{metadata["nam"]}\" --album \"#{metadata["alb"]}\" --artist \"#{metadata["ART"]}\" --genre \"Audiobooks\" --stik \"Audiobook\" --artwork \"#{cover_path}\" --overWrite"
end

metadata = get_metadata(ARGV[0])
filename = make_filename(ARGV[0], metadata)
cover = get_cover(ARGV[0])

system crush_file(ARGV[0], filename)
system apply_metadata(filename, metadata, cover)
system "rm \"#{cover}\""
