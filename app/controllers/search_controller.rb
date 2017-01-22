class SearchController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  skip_authorization_check

  respond_to :html

  def index
    @results = SearchService.call(params[:query], params[:class])
  end
end
