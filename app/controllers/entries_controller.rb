class EntriesController < ApplicationController

  before_filter :login_required, :except => [:show, :index]
  before_filter :find_entry, :except => [:index, :new, :create]

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
    term = @entry.term_in_source_language
    if @entry.destroy
      flash[:success] = "Entry \"#{term}\" has been deleted."
    end
    redirect_to homepage_path
  end

  def index
  end

  private

  def find_entry
    @entry = Entry.find_by_id!(params[:id])
  end

end
