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
    user = User.find_by_name(args.username)
    csv_text = File.read(args.filename)
    csv = CSV.parse(csv_text, :headers => true)
    csv.each do |row|
      row = row.to_hash.with_indifferent_access
      entry = Entry.new(row.to_hash.symbolize_keys.merge(:user => user))
      term = entry.term_in_glossary_language
      i = 0
      while (Entry.find_by_term_in_glossary_language(entry.term_in_glossary_language)) 
        entry.term_in_glossary_language = term + (i += 1).to_s
      end
      if entry.save
        puts "Entry '#{entry.term_in_glossary_language}' saved."
      else
        puts "Entry save failed for '#{term}'."
      end
    end
  end

end
