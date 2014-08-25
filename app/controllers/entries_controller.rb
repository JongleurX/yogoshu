class EntriesController < ApplicationController
#  respond_to :html, :json
  autocomplete :entry, :term, :class_name => Entry.translation_class, :scopes => [:accessible]

  before_filter :login_required, :except => [:show, :index, :autocomplete_entry_term]
  before_filter :find_entry, :except => [:index, :new, :create, :autocomplete_entry_term]
  before_filter :authorize, :only => [:destroy, :update, :edit]
  before_filter :manager_authorize, :only => [:approve]

  def show
    raise_not_found unless (logged_in? or @entry.approved?)
  end

  def new
    @entry = Entry.new
  end

  def create
    @entry = Entry.new(params[:entry])
    @entry.user_id = current_user.id
    if @entry.save
      flash[:success] = I18n.t('ui.entry_created')
      redirect_to @entry
    else
      flash.now[:error] = I18n.t('ui.data_entry_error')
      render "new"
    end
  end

  def update
    respond_to do |format|
      if (@entry.update_attributes(params[:entry]))
#        format.json { respond_with_bip(@entry) }
        format.html {
          flash[:success] = I18n.t('ui.entry_updated', :entry => @entry.term_in_glossary_language)
          redirect_to @entry
        }
      else
#        format.json { respond_with_bip(@entry) }
        format.html { 
          flash.now[:error] = I18n.t('ui.entry_not_updated', :entry => @entry.term_in_glossary_language)
          render "edit"
        }
      end
    end
  end

  def approve
    if @entry.update_attributes({ :approved => params[:entry][:approved] }, :as => :manager)
      flash[:success] = I18n.t('ui.entry_approval_changed', :entry => @entry.term_in_glossary_language, :approval => (@entry.approved == true) ? I18n.t('ui.approved') : I18n.t('ui.unapproved') )
    else
      flash[:error] = I18n.t('ui.entry_approval_unchanged', :entry => @entry.term_in_glossary_language)
    end
    redirect_to :back
  end

  def history
  end

  def edit
  end

  def destroy
    term = @entry.term_in_glossary_language
    if @entry.destroy
      flash[:success] = I18n.t('ui.entry_deleted', :entry => term)
    end
    if !(request.referrer.blank?)
      redirect_to '/entries' + (request.referrer.slice(/\?.*/) || "")
    else
      redirect_to entries_path
    end
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
    raise_not_found if @entry.nil?
  end

  def authorize
    unless @entry.changeable_by?(current_user)
      flash[:error] = I18n.t('ui.entry_changes_forbidden')
      redirect_to entry_path(@entry)
#      render :text => 'Unauthorized', :status => :unauthorized
    end
  end

  def manager_authorize
    unless manager?
      flash[:error] = I18n.t('ui.entry_approval_forbidden')
      redirect_to entry_path(@entry)
    end
  end
end
