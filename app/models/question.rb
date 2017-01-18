class Question < ApplicationRecord
  include Votable
  include Commentable


  has_many :attachments, as: :attachable, dependent: :destroy
  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :title, :body, :user_id, presence: true

  validates :title, length: { in: 5..100 }
  validates :body, length: { in: 5..1000 }

  accepts_nested_attributes_for :attachments, reject_if: :all_blank, allow_destroy: true
  after_create :actioncable_question
  scope :ordered, -> { order(created_at: :desc) }

  private

  def actioncable_question
    ActionCable.server.broadcast '/questions',
                                 ApplicationController.render(
                                   partial: 'questions/new_question',
                                   locals: { question: self }
                                 )
  end
end
