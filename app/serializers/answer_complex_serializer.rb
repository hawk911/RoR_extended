class AnswerComplexSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :updated_at, :question_id, :user_id

  has_many :attachments
  has_many :comments
end
