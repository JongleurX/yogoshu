class Entry < ActiveRecord::Base
  include Yogoshu::Locale

  translates :term

  # associations
  belongs_to :user

  # validations
  validates :user_id, :presence => true
  validates :source_language, :presence => true, :inclusion => Yogoshu::Locale.base_languages.map(&:to_s)
#  validates :term, :translation_presence => { :lang => Yogoshu::Locale.default_source_language }, :translation_uniqueness => { :lang => Yogoshu::Locale.default_source_language }

  Yogoshu::Locale.base_languages.each do |lang|
    eval <<-END_RUBY
    validates :term_in_#{lang}, :presence => true, :translation_uniqueness => { :lang => :#{lang} }, :if => Proc.new { |entry| entry.source_language == '#{lang}' }
    END_RUBY
  end

  before_validation :set_default_source_language

  def in_source_language?
    (self.source_language == Globalize.locale.to_s) or (self.source_language == nil)
  end

  protected

  def set_default_source_language
    self.source_language ||= Yogoshu::Locale.default_source_language.to_s
  end

end
