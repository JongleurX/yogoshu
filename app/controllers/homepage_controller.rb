class HomepageController < ApplicationController

  def index
    @entry = Entry.new
  end

end
