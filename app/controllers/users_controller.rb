class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  respond_to :html
  before_action :set_user

  def show
    respond_with(@user)
  end

  private

  def set_user
    @user = User.find(params[:id])
    authorize @user
  end
end
