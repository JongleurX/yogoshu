module Yogoshu

  module Locales

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
      raise ArgumentError, "Glossary language must be a Symbol" unless locale.class == Symbol
      @@glossary_language = locale unless !@@base_languages.include?(locale)
    end

    def self.glossary_language
      @@glossary_language
    end

    def glossary_language
      @@glossary_language
    end

  end

  module ActsAsGlossary

    def translates(*attr_names)
      include InstanceMethods
      extend ClassMethods

      super
    end

    module Postfixes
      include Locales

      def postfix_attr_names
        %w[ glossary_language ]
      end

      def postfix
        base_languages.map(&:to_s) + postfix_attr_names
      end
    end

    module InstanceMethods
      include Postfixes, Locales

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

    module ClassMethods
      include Postfixes, Locales

      def respond_to?(method, priv=false)
        (method.to_s =~ /^find_by_(\w+)_in_(\w+)$/ && translated?($1) && postfix.include?($2)) ? respond_to?("find_by_" + $1, priv) : super
      end

      def method_missing(sym, *args)
        if sym.to_s =~ /^find_by_(\w+)_in_(\w+)$/ && translated?($1) && postfix.include?($2)
          lang = postfix_attr_names.include?($2) ? eval($2) : $2
          element = translation_class.find :first, :conditions => { :locale => lang, $1.to_sym => args[0] }
          element.nil? ? nil : element.send(self.to_s.underscore)
        else
          super
        end
      end
    end
  end
end

ActiveRecord::Base.extend(Yogoshu::ActsAsGlossary)
ActiveRecord::Base.extend(Yogoshu::Locales)
