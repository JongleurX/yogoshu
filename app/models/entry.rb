class Entry < ActiveRecord::Base
  include Yogoshu::Locale

  default_scope where(:source_language => Yogoshu::Locale.glossary_language.to_s)

  translates :term

  # associations
  belongs_to :user

  # validations
  validates :user_id, :presence => true
  validates :source_language, :presence => true, :inclusion => Yogoshu::Locale.base_languages.map(&:to_s)

  Yogoshu::Locale.base_languages.each do |lang|
    eval <<-END_RUBY
    validates :term_in_#{lang}, :presence => true, :translation_uniqueness => { :lang => :#{lang}, :message => "is already in the glossary"}, :if => Proc.new { |entry| entry.source_language == '#{lang}'}, :on => :create
    END_RUBY
  end

  def to_param
    term_in_source_language
  end

  def in_source_language?
    (source_language == Globalize.locale.to_s) or (source_language == nil)
  end

  class << self
    def respond_to?(method, priv=false)
      eval <<-END_RUBY
      case method
        when /^(find_by_[_a-zA-Z]\\w*)_in_(#{Yogoshu::Locale.base_languages.join("|")})$/
          self.translation_class.respond_to?($1, priv)
        when /^(find_by_[_a-zA-Z]\\w*)_in_(source_language|glossary_language)$/
          self.translation_class.respond_to?($1, priv)
        else
          super
      end
      END_RUBY
    end

    def method_missing(sym, *args)
      eval <<-END_RUBY
      case sym.to_s
        when /^(find_by_[_a-zA-Z]\\w*)_in_(#{Yogoshu::Locale.base_languages.join("|")})$/
          nil
        when /^(find_by_[_a-zA-Z]\\w*)_in_source_language$/
          nil
        else
         super
      end
      END_RUBY
    end

  end

end
