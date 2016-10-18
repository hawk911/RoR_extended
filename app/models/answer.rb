class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, :question_id, :user_id, presence: true

  default_scope { order(best: :desc, created_at: :asc) }

  def toggle_best!
    transaction do
      Answer.where(question_id: question_id, best: true).where.not(id: id).update_all(best: false)
      update!(best: !best?)
    end
  end
end
