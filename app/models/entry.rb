class Entry < ActiveRecord::Base
  default_scope where(:source_language => glossary_language.to_s)

  translates :term

  # associations
  belongs_to :user

  # validations
  validates :user_id, :presence => true
  validates :source_language, :presence => true, :inclusion => base_languages.map(&:to_s)

  base_languages.each do |lang|
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

end
