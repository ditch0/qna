class SearchController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  skip_authorization_check

  respond_to :html

  def index
    query = params[:query]
    @results = if query.blank?
                 []
               else
                 ThinkingSphinx.search ThinkingSphinx::Query.escape(query), classes: search_classes
               end
  end

  private

  def search_classes
    available_classes = %w(Question Answer Comment User)
    selected_class = params[:class]
    classes_for_search = available_classes.include?(selected_class) ? [selected_class] : available_classes
    classes_for_search.map(&:constantize)
  end
end
