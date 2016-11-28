class Answer < ApplicationRecord
  include Votable

  has_many :attachments, as: :attachable, dependent: :destroy
  belongs_to :question
  belongs_to :user

  validates :body, :question_id, :user_id, presence: true

  accepts_nested_attributes_for :attachments, reject_if: proc { |a| a[:file].blank? }, allow_destroy: true

  default_scope { order(best: :desc, created_at: :asc) }

  def toggle_best!
    return false unless valid?
    transaction do
      Answer.where(question_id: question_id, best: true).where.not(id: id).update_all(best: false)
      update!(best: !best?)
    end
  end
end
