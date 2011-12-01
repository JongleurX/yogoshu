require 'yogoshu/locale'

# sets base languages to be used throughout the application
Yogoshu::Locale.set_base_languages(:en, :ja)

# sets the default source language for all entries in the glossary
Yogoshu::Locale.set_default_source_language :en

Yogoshu::Locale.base_languages.each do |lang|
  Entry.class.__send__(:attr_accessor, "term_in_" + lang.to_s)
end
