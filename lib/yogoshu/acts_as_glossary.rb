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
          ($3 == '=') ? write_attribute($1, args[0], { :locale => lang }) : read_attribute($1, { :locale => lang }) unless lang.nil?
        else
          super
        end
      end
    end

    # ClassMethods respond_to? and method_missing code derived from globalize3 (globalize/active_record/class_methods.rb)
    module ClassMethods
      include Postfixes, Locales

      def match_with_postfix(method_id)
        if method_id.to_s =~ /^([_a-zA-Z]\w*)_in_(\w+)$/ && postfix.include?($2) && (match = ::ActiveRecord::DynamicFinderMatch.match($1) || ::ActiveRecord::DynamicScopeMatch.match($1))
          lang = postfix_attr_names.include?($2) ? eval($2) : $2
          return [match, lang]
        else
          return nil
        end
      end

      def respond_to?(method_id, priv=false)
        supported_on_missing_with_postfix?(method_id) ? true : super
      end

      def supported_on_missing_with_postfix?(method_id)
        match, lang = match_with_postfix(method_id)
        return false if match.nil?
        attribute_names = match.attribute_names.map(&:to_sym)
        translated_attributes = attribute_names & translated_attribute_names
        return false if translated_attributes.empty?

        untranslated_attributes = attribute_names - translated_attributes
        return false if untranslated_attributes.any?{|unt| ! respond_to(:"scoped_by_#{unt}")}

        return [match, attribute_names, translated_attributes, untranslated_attributes, lang]
      end

      def method_missing(method_id, *args, &block)
        match, attribute_names, translated_attributes, untranslated_attributes, lang = supported_on_missing_with_postfix?(method_id)
        return super unless match

        scope = scoped

        translated_attributes.each do |attr|
          scope = scope.with_translated_attribute(attr, args[attribute_names.index(attr)], lang)
        end

        untranslated_attributes.each do |unt| 
          index = attribute_names.index(unt) 
          raise StandarError unless index 
          scope = scope.send(:"scoped_by_#{unt}", arguments[index]) 
        end 

        if match.is_a?(::ActiveRecord::DynamicFinderMatch)
          found = scope.send(match.finder)
          return nil if found.nil?
          return found.is_a?(Array) ? found.map(&:reload) : found.reload
        end
        return scope   
      end
    end
  end
end

ActiveRecord::Base.extend(Yogoshu::ActsAsGlossary)
ActiveRecord::Base.extend(Yogoshu::Locales)
