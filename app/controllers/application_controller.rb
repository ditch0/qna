require 'application_responder'

class ApplicationController < ActionController::Base
  include CanCan::ControllerAdditions

  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception
  before_action :authenticate_user!

  check_authorization unless: :devise_controller?

  rescue_from CanCan::AccessDenied do
    respond_to do |format|
      format.json { head :forbidden }
      format.html { redirect_to root_url, alert: 'Not allowed.' }
      format.js   { head :forbidden }
    end
  end
end
