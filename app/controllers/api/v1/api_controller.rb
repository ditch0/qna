module Api
  module V1
    class ApiController < ActionController::Base
      before_action :doorkeeper_authorize!
      respond_to :json
      check_authorization

      rescue_from CanCan::AccessDenied do
        head :forbidden
      end

      protected

      def current_resource_owner
        @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
      end

      alias current_user current_resource_owner # required by CanCanCan
    end
  end
end
