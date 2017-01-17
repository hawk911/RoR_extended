class Answer < ApplicationRecord
  include Votable
  include Commentable

  has_many :attachments, as: :attachable, dependent: :destroy
  belongs_to :question
  belongs_to :user

  validates :body, :question_id, :user_id, presence: true
  after_create :actioncable_answer
  accepts_nested_attributes_for :attachments, reject_if: proc { |a| a[:file].blank? }, allow_destroy: true

  default_scope { order(best: :desc, created_at: :asc) }

  def toggle_best!
    return false unless valid?
    transaction do
      Answer.where(question_id: question_id, best: true).where.not(id: id).update_all(best: false)
      update!(best: !best?)
    end
  end

  private

  def actioncable_answer
    return if errors.any?

    answer_attachments = []
    attachments.each do |a|
      attach = {}
      attach[:id] = a.id
      attach[:file_url] = a.file.url
      attach[:file_name] = a.file.identifier
      answer_attachments << attach
     end

    ActionCable.server.broadcast(
      "answers_question_#{question.id}",
      answer:             self,
      answer_attachments: answer_attachments,
      answer_votes:       self.total
    )
  end
end
