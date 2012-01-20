class EntriesController < ApplicationController
  respond_to :html, :json

  autocomplete :entry, :term, :class_name => Entry.translation_class

  before_filter :login_required, :except => [:show, :index, :autocomplete_entry_term]
  before_filter :find_entry, :except => [:index, :new, :create]
  before_filter :authorize, :only => [:destroy, :update]

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
    @entry.update_attributes!(params[:entry])
    respond_with_bip @entry
#      flash[:success] = "Entry \"#{@entry.term_in_glossary_language}\" has been updated."
#      redirect_to :back
#    else
#      flash[:error] = "Entry could not be updated."
#      redirect_to :back
#    end
  end

  def destroy
    term = @entry.term_in_glossary_language
    if @entry.destroy
      flash[:success] = "Entry \"#{term}\" has been deleted."
    end
    redirect_to entries_path
  end

  def index
    if (searchstring = params[:search]).present?
      @tokens = searchstring.split 
      @entries_translations = Entry.translation_class.find(:all, :conditions => [(['LOWER(term) LIKE ?'] * @tokens.length).join(' or ')] + @tokens.map { |token| "%#{token.downcase}%" })
      @entries = (@entries_translations.map { |t| Entry.find(t.entry_id) }).uniq
    else
      params[:search] = nil
      @entries = Entry.all
    end
    if !(logged_in?)
      @entries.delete_if { |e| !(e.approved?) }
    end
  end

  private

  def find_entry
    @entry = Entry.find_by_term_in_glossary_language(params[:id])
  end

  def authorize
    unless @entry.changeable_by?(current_user)
      render :text => 'Unauthorized', :status => :unauthorized
    end
  end

end
