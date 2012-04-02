require 'csv'

namespace :csv do

  # import glossary entries from a csv file
  #
  # create a user to add the entries and specify the user in the username variable, as in:
  # rake csv:import[csv-file,importer]
  # for a user named "importer"
  #
  # first line is a header and should include term_in_<lang> for each language in the glossary
  # plus optionally "note" for translator notes
  # entries with duplicate terms in the glossary language are entered with an index
  task :import, [:filename, :username] => [:environment] do |t, args|
    raise ArgumentError, "ERROR: User '#{args.username}' not found." unless user = User.find_by_name(args.username)
    raise IOError, "ERROR: Unable to open CSV file." unless csv_text = File.read(args.filename)
    raise IOError, "ERROR: Unable to parse CSV file." unless csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      row = row.to_hash.with_indifferent_access
      entry = Entry.new(row.to_hash.symbolize_keys)
      entry.user_id = user.id
      term = entry.term_in_glossary_language
      if !(entry.save)
        puts "Entry save failed for '#{term}'"
      end
    end
  end

end
