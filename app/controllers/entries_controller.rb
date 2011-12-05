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
      redirect_to @entry
    else
      flash.now[:error] = "There were errors in the information entered."
      render "new"
    end
  end

  def update
    if @entry.update_attributes!(params[:entry])
      flash[:success] = "Entry \"#{@entry.term}\" has been updated."
      redirect_to :back
    else
      flash[:error] = "Entry could not be updated."
      redirect_to :back
    end
  end

  def destroy
    term = @entry.term_in_source_language
    if @entry.destroy
      flash[:success] = "Entry \"#{term}\" has been deleted."
    end
    redirect_to entries_path
  end

  def index
    if params[:search]
      @entries_translations = Entry.translation_class.where("term LIKE ?", "%#{params[:search]}%")
      @entries = (@entries_translations.map { |t| Entry.find(t.entry_id) }).uniq
    else
      @entries = Entry.all
    end
    if !(logged_in?)
      @entries.delete_if { |e| !(e.approved?) }
    end
  end

  private

  def find_entry
    entries = Entry.all.select { |e| e.term_in_source_language == params[:id] } 
    if entries.empty?
      raise ActiveRecord::RecordNotFound, "Couldn't find Entry with term_in_source_language = #{params[:id]}"
    end
    @entry = entries.first
  end

end
