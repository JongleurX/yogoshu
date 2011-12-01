class EntriesController < ApplicationController

  before_filter :login_required, :except => [:search, :show]

  def show
  end

  def new
    @entry = Entry.new
  end

  def create
    @entry = Entry.new(params[:entry].merge(:user_id => current_user.id))
    if @entry.save
      flash[:success] = "New glossary entry has been created."
      redirect_to entry_path(@entry)
    else
      flash.now[:error] = "There were errors in the information entered."
      render "new"
    end
  end

  def destroy
  end

end
