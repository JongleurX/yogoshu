class Entry < ActiveRecord::Base
  include Permissions

  translates :term

  # associations
  belongs_to :user

  # validations
  validates :user_id, :presence => true

  base_languages.each do |lang|
    eval <<-END_RUBY
    validates :term_in_#{lang}, :presence => true, :translation_uniqueness => { :lang => :#{lang}, :message => "is already in the glossary"}, :if => Proc.new { |entry| entry.glossary_language == :#{lang}}, :on => :create
    END_RUBY
  end

  def to_param
    term_in_glossary_language
  end

end

class Entry::Translation
  belongs_to :entry
  scope :accessible, lambda { includes(:entry).where(:entries => {:approved => true}) unless User.current_user.is_a?(User) }
end
