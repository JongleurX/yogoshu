class UsersController < ApplicationController
  before_filter :login_required, :except => [:index, :show]
  before_filter :find_user, :except => [:index, :new, :create]
  before_filter :access_restricted, :only => [:new, :create]

  def index
    @users = User.find(:all)
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = I18n.t('ui.user_created', :user => @user.name)
      redirect_to @user
    else
      flash.now[:error] = I18n.t('ui.data_entry_error')
      render "new"
    end
  end

  def show
  end

  def update
    name = @user.name
    if @user.update_attributes(params[:user])
      flash[:success] = I18n.t('ui.user_updated', :user => @user.name)
      redirect_to @user
    else
      flash.now[:error] = I18n.t('ui.data_entry_error')
      # reset name in case it was changed
      @user.name = name
      render "edit"
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = I18n.t('ui.user_deleted', :user => @user.name)
    end
    redirect_to users_path
  end

  private

  def find_user
    @user = User.find_by_name!(params[:id])
  end

end
