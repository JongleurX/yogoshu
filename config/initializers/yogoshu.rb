require 'yogoshu/acts_as_glossary'
require 'yogoshu/permissions'

# sets base languages to be used throughout the application
Yogoshu::Locales.set_base_languages(:ja, :en)

# sets the default source language for all entries in the glossary
Yogoshu::Locales.set_glossary_language :ja
