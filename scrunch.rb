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

def apply_metadata(file, metadata, cover)
  %{AtomicParsley \"#{file}\"                     \
                  --title \"#{metadata["nam"]}\"  \
                  --album \"#{metadata["alb"]}\"  \
                  --artist \"#{metadata["ART"]}\" \
                  --genre \"Audiobooks\"          \
                  --stik \"Audiobook\"            \
                  --artwork \"#{path}\"           \
                  --overWrite
  }
end

def on_path?(prog_name)
  !`which "#{prog_name}"`.empty?
end

def assert_required(prog_name)
  if !on_path? prog_name then
    puts "Could not find required program \"#{prog_name}\".\n"
    exit
  end
end

if ARGV.length != 1 then
  usage = "usage: scrunch <audiobook>"
  puts usage
  exit
end

assert_required "AtomicParsley"
assert_required "afconvert"

input_filename = ARGV[0]

metadata = get_metadata(input_filename)
filename = make_filename(input_filename, metadata)
cover = get_cover(input_filename)

system crush_file(input_filename, filename)
system apply_metadata(filename, metadata, cover)
system "rm \"#{cover}\""
