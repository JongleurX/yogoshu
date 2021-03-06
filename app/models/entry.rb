class Entry < ActiveRecord::Base
  include Permissions

  attr_accessible :term, :note
  attr_accessible :term, :info
  Yogoshu::Locales.base_languages.each { |lang| attr_accessible :"term_in_#{lang}" }
  attr_accessible :approved, :as => :manager

  has_paper_trail
  translates :term, :versioning => :paper_trail

  # associations
  belongs_to :user

  # validations
  validates :user_id, :presence => true
  base_languages.each do |lang|
    validates :"term_in_#{lang}", :presence => true, :translation_uniqueness => { :message => I18n.t('ui.entry_already_present')}, :if => Proc.new { |entry| entry.glossary_language == :"#{lang}"}
  end

  def to_param
    term_in_glossary_language
  end

end

class Entry::Translation
  belongs_to :entry
#  TODO: add line below
#  belongs_to :entry, :inverse_of => :translations
  scope :accessible, lambda { includes(:entry).where(:entries => {:approved => true}) unless User.current_user.is_a?(User) }
end
