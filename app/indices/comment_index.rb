ThinkingSphinx::Index.define :comment, with: :active_record do
  indexes body

  has user_id, commentable_id, commentable_type, created_at, updated_at
end
