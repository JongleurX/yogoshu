class EntriesController < ApplicationController

  before_filter :login_required, :except => [:search, :show]

  def show
  end

  def new
    @entry = Entry.new
  end

  def create
  end

  def destroy
  end

end
