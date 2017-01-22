class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:show]
  authorize_resource
  respond_to :html
  before_action :set_user

  def show
    respond_with(@user)
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
