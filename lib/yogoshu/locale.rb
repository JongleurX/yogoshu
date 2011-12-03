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
      when /(\\w+)_in_(#{base_languages.join("|")})$/
        respond_to?($1, priv)
      when /(\\w+)_in_(#{base_languages.join("|")})=$/
        respond_to?($1, priv)
      else
        super
      end
      END_RUBY
    end

    def method_missing(sym, *args)
      eval <<-END_RUBY
      case sym.to_s
      when /(\\w+)_in_(#{base_languages.join("|")})$/
        read_attribute $1, $2
      when /(\\w+)_in_(#{base_languages.join("|")})=$/
        write_attribute $1, args[0], $2 
      else
        super
      end
      END_RUBY
    end
  end
end
