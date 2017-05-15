module Api
  module V1
    class ApiController < ActionController::Base
      include Pundit

      before_action :doorkeeper_authorize!
      after_action :verify_authorized
      respond_to :json

      rescue_from Pundit::NotAuthorizedError do
        head :forbidden
      end

      protected

      def current_resource_owner
        @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
      end

      alias current_user current_resource_owner # required by Pundit
    end
  end
end
