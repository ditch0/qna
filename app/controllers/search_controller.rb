class SearchController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  skip_after_action :verify_authorized

  respond_to :html

  def index
    @results = SearchService.call(params[:query], params[:class])
  end
end
