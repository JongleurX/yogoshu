class UsersController < ApplicationController
  respond_to :html, :json

  before_filter :login_required, :except => [:index, :show]
  before_filter :find_user, :except => [:index, :new, :create]
  before_filter :access_restricted, :only => [:new, :create]

  def index
    @users = User.find(:all)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "User #{@user.name} has been created."
      redirect_to @user
    else
      flash.now[:error] = "There were errors in the information entered."
      render "new"
    end
  end

  def show
  end

  def update
    @user.update_attributes!(params[:user])
    respond_with_bip @user
  end

  def destroy
    if @user.destroy
      flash[:success] = "User #{@user.name} has been destroyed."
    end
    redirect_to users_path
  end

  private

  def find_user
    @user = User.find_by_name!(params[:id])
  end

end
