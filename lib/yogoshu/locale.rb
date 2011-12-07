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

    def self.set_default_source_language(locale)
      @@default_source_language = locale unless !@@base_languages.include?(locale)
    end

    def self.default_source_language
      @@default_source_language
    end

    def default_source_language
      @@default_source_language
    end

    def respond_to?(method, priv=false)
      eval <<-END_RUBY
      case method
      when /^([_a-zA-Z]\\w*)_in_(#{base_languages.join("|")}|source_language)=?$/
        self.class.translation_class.column_names.include?($1) ? respond_to?($1, priv) : super
      else
        super
      end
      END_RUBY
    end

    def method_missing(sym, *args)
      eval <<-END_RUBY
      case sym.to_s
      when /^([_a-zA-Z]\\w*)_in_(#{base_languages.join("|")})$/
        self.class.translation_class.column_names.include?($1) ? read_attribute($1, $2) : super
      when /^([_a-zA-Z]\\w*)_in_(#{base_languages.join("|")})=$/
        self.class.translation_class.column_names.include?($1) ? write_attribute($1, args[0], $2) : super
      when /^([_a-zA-Z]\\w*)_in_source_language$/
        self.class.translation_class.column_names.include?($1) ? (read_attribute($1, source_language) unless source_language.nil? ) : super
      when /^([_a-zA-Z]\\w*)_in_source_language=$/
        self.class.translation_class.column_names.include?($1) ? (write_attribute($1, args[0], source_language) unless source_language.nil? ) : super
      else
        super
      end
      END_RUBY
    end
  end
end
