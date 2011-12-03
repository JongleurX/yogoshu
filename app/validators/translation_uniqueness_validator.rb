class TranslationUniquenessValidator < ActiveModel::EachValidator

  # to fix problem with Globalize3 uniqueness validation: https://github.com/svenfuchs/globalize3/issues/7
  def validate_each(record, attr, value)
    klass = record.class.translation_class
    element = klass.find :first, :conditions => { :locale => options[:lang], attr.to_s.gsub(/_in_(\w+)/, '').to_sym => value }
    record.errors.add(attr, options[:message] || :taken) if element
  end
end
