class EntriesController < ApplicationController
#  respond_to :html, :json
  autocomplete :entry, :term, :class_name => Entry.translation_class, :full => true, :scopes => [:accessible]

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
    respond_to do |format|
      if (@entry.update_attributes!(params[:entry]))
        format.json { respond_with_bip(@entry) }
        format.html {
          flash[:success] = "Entry \"#{@entry.term_in_glossary_language}\" has been updated."
          redirect_to(:back) 
        }
      else
        format.json { respond_with_bip(@entry) }
        format.html { 
          flash[:error] = "Entry could not be updated."
          redirect_to(:back)
        }
      end
    end
  end

  def destroy
    term = @entry.term_in_glossary_language
    if @entry.destroy
      flash[:success] = "Entry \"#{term}\" has been deleted."
    end
    redirect_to entries_path
  end

  def index
    scope = (logged_in?) ? Entry.scoped : Entry.where(approved: true)
    scope = scope.includes(:user).with_translations(base_languages)
    if (searchstring = params[:search]).present?
      (@tokens = searchstring.split).each do |token|
        scope = scope.where('LOWER(term) LIKE ?', "%#{token.downcase}%")
      end
    else
      params[:search] = nil
    end
    @entries = scope.order(:term).page(params[:page])
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
