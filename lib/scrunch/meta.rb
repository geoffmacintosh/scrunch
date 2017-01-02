# The part that deals with metadata collection and generation.
module Meta
  def self.get_metadata(file)
    atoms = `AtomicParsley \"#{file}\" -t`
    atoms.each_line.each_with_object({}) do |line, hash|
      prefix, contents = line.split(": ")
      atom_name = /([\w]{3,4})(?=\" contains)/.match(prefix).to_s
      hash[atom_name] = contents.strip unless atom_name.empty?
      hash
    end
  end

  def self.get_cover(input_file)
    unprocessed = `AtomicParsley \"#{input_file}\" -E`
    /(?<=\: ).*/.match(unprocessed).to_s
  end

  def self.make_filename(input_file)
    input_file[0...-4] + "-new.m4b"
  end

  def self.apply_metadata(file, metadata, cover)
    %(AtomicParsley \"#{file}\" \
--title \"#{metadata["nam"]}\" \
--album \"#{metadata["alb"]}\" \
--artist \"#{metadata["ART"]}\" \
--genre \"Audiobooks\" \
--stik \"Audiobook\" \
--artwork \"#{cover}\" \
--overWrite \
2>&1 1>/dev/null)
  end
end
