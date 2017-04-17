class QuestionComplexSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :user_id, :created_at, :updated_at

  has_many :attachments
  has_many :comments
end
