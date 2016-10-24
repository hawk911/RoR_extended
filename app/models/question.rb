class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  has_many :attachments
  belongs_to :user

  validates :title, :body, :user_id, presence: true

  accepts_nested_attributes_for :attachments
  scope :ordered, -> { order(created_at: :desc) }
end
