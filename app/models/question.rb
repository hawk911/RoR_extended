class Question < ApplicationRecord
  scope :ordered, -> { order(created_at: :desc) }

  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :title, :body, presence: true
end
