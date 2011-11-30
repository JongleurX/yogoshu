class UsersController < ApplicationController

  before_filter :login_required, :except => [:index, :show]
  before_filter :find_user, :except => [:index, :new, :create]

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
      render "new"
    end
  end

  def show
  end

  def update
  end

  def destroy
  end

  private

  def find_user
    @user = User.find_by_name!(params[:id])
  end

end
