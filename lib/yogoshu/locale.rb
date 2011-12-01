module Yogoshu
  module Locale

    def self.set_base_languages(*locales)
      @@base_languages = locales
      @@METHOD_IN_LANG_GETTER_RE = "/(\\w+)_in_(" + locales.join("|") + ")$/"
      @@METHOD_IN_LANG_SETTER_RE = "/(\\w+)_in_(" + locales.join("|") + ")=$/"
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
      case method
      when eval(@@METHOD_IN_LANG_GETTER_RE)
        respond_to?($1, priv)
      when eval(@@METHOD_IN_LANG_SETTER_RE)
        respond_to?($1, priv)
      else
        super
      end
    end

    def method_missing(sym, *args)
      case sym.to_s
      when eval(@@METHOD_IN_LANG_GETTER_RE)
        read_attribute $1, $2
      when eval(@@METHOD_IN_LANG_SETTER_RE)
        write_attribute $1, args[0], $2 
      else
        super
      end
    end
  end
end
