class Entry < ActiveRecord::Base
  include Yogoshu::Locale

  translates :term

  # associations
  belongs_to :user

  # validations
  validates :user_id, :presence => true
  validates :source_language, :presence => true
  validates :term, :presence => true, :if => :in_source_language?

  def in_source_language?
    (self.source_language == Globalize.locale.to_s) or (self.source_language == nil)
  end

end
