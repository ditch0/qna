class SearchService
  SEARCH_CLASSES = [Question, Answer, Comment, User].freeze

  def self.call(query, search_class_name = nil)
    return [] if query.blank?
    ThinkingSphinx.search ThinkingSphinx::Query.escape(query), classes: classes_for_search(search_class_name)
  end

  private_class_method

  def self.classes_for_search(search_class_name)
    return SEARCH_CLASSES if search_class_name.blank?

    klass = begin
      search_class_name.constantize
    rescue => exception
      Rails.logger.warn "Unable to find class for #{search_class_name}, caused by: #{exception}"
    end

    if !klass.nil? && SEARCH_CLASSES.include?(klass)
      [search_class_name.constantize]
    else
      SEARCH_CLASSES
    end
  end
end
