class TranslationUniquenessValidator < ActiveModel::EachValidator

  # validates postfix notation accessors for translated attributes
  def validate_each(record, attr, value)
    klass = record.class
    matched, attribute, locale = *(/^(.+)_in_(\w+)$/.match(attr) ||
                                   [nil, attr, Globalize.locale])
    if klass.translates? && klass.translated_attribute_names.include?(attribute.to_sym)
      t_class = klass.translation_class
      table = t_class.arel_table

      relation = table[attribute.to_sym].eq(value).and(table[:locale].eq(locale.to_s))
      relation = relation.and(table[:"#{klass.name.downcase}_id"].not_eq(record.send(:id))) if record.persisted?

      if t_class.unscoped.where(relation).exists?
        record.errors.add(attribute, :taken, options.except(:case_sensitive, :scope).merge(:value => value))
      end
    end
  end
end
