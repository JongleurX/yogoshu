class EntriesController < ApplicationController

  before_filter :login_required, :except => [:search]

  def show
  end

  def new
  end

  def create
  end

  def destroy
  end

end
