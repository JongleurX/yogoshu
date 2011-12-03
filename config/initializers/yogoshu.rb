require 'yogoshu/locale'

# sets base languages to be used throughout the application
Yogoshu::Locale.set_base_languages(:ja, :en)

# sets the default source language for all entries in the glossary
Yogoshu::Locale.set_default_source_language :ja
