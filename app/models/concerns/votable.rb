module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def set_evaluate(user, value)
    votes.create(user: user, value: value)
  end
end
