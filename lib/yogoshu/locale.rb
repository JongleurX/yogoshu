module Yogoshu
  module Locale

    def self.set_base_languages(*locales)
      locales.each do |locale|
        raise ArgumentError, "Base languages must be Symbols" unless locale.class == Symbol
      end
      @@base_languages = locales
    end

    def self.base_languages
      @@base_languages
    end

    def base_languages
      @@base_languages
    end

    def self.set_glossary_language(locale)
      @@glossary_language = locale unless !@@base_languages.include?(locale)
    end

    def self.glossary_language
      @@glossary_language
    end

    def glossary_language
      @@glossary_language
    end

    def postfix_attr_names
      %w[source_language glossary_language]
    end

    def postfix
      base_languages.map(&:to_s) + postfix_attr_names
    end

    def respond_to?(method, priv=false)
      (method.to_s =~ /^(\w+)_in_(\w+)=?$/ && translated?($1) && postfix.include?($2)) ? respond_to?($1, priv) : super
    end

    def method_missing(sym, *args)
      if sym.to_s =~ /^(\w+)_in_(\w+)(=|)$/ && translated?($1) && postfix.include?($2)
        lang = postfix_attr_names.include?($2) ? eval($2) : $2
        ($3 == '=') ? write_attribute($1, args[0], lang) : read_attribute($1, lang) unless lang.nil?
      else
        super
      end
    end
  end
end
