ThinkingSphinx::Index.define :question, with: :active_record do
indexes title
indexes body
indexes user.email, as: author, sortable:true

has user_id, create_at, udpate_at
end
