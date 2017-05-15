require 'application_responder'

class ApplicationController < ActionController::Base
  include Pundit

  self.responder = ApplicationResponder
  respond_to :html

  protect_from_forgery with: :exception
  before_action :authenticate_user!
  after_action :verify_authorized, unless: :devise_controller?

  rescue_from Pundit::NotAuthorizedError do
    respond_to do |format|
      format.json { head :forbidden }
      format.html { redirect_to root_url, alert: 'Not allowed.' }
      format.js   { head :forbidden }
    end
  end
end
