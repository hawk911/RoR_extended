require 'rails_helper'

describe 'Ability' do
  subject(:ability){ Ability.new(user) }

  describe 'for guest' do
    let(:user){ nil }
    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }

  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }
    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other_user) { create :user  }
    let(:his_question)    { create(:question, user: user) }
    let(:other_question) { create(:question, user: other_user) }
    let(:his_answer)      { create(:answer, user: user) }
    let(:other_answer)   { create(:answer, user: other_user) }
    let(:his_subscription)    { create(:subscription, user: user) }
    let(:others_subscription) { create(:subscription, user: other_user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    # Create
    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }
    it { should be_able_to :create, Subscription }

    # Update
    it { should be_able_to :update, create(:question, user: user) }
    it { should_not be_able_to :update, create(:question, user: other_user) }

    it { should be_able_to :update, create(:answer, user: user) }
    it { should_not be_able_to :update, create(:answer, user: other_user) }

    it { should be_able_to :update, create(:comment, user: user) }
    it { should_not be_able_to :update, create(:comment, user: other_user) }

    it { should be_able_to :destroy, his_subscription }
    it { should_not be_able_to :destroy, others_subscription }

    # Destroy
    it { should be_able_to :destroy, his_question }
    it { should_not be_able_to :destroy, other_question }

    it { should be_able_to :destroy, his_answer }
    it { should_not be_able_to :destroy, other_answer }

    # Set best answer
    it { should be_able_to :set_best, create(:answer, question: his_question) }
    it { should_not be_able_to :set_best, create(:answer, question: other_question) }

    # Votes
    it { should be_able_to :like, other_question }
    it { should_not be_able_to :like, his_question }

    it { should be_able_to :dislike, other_question }
    it { should_not be_able_to :dislike, his_question }
    context 'Vote#change_vote' do
      before { other_answer.set_evaluate(user, 1) }
      it { should be_able_to :change_vote, other_answer }
      it { should_not be_able_to :change_vote, his_answer }
    end

    context 'Vote#cancel_vote' do
      before { other_answer.set_evaluate(user, 1) }
      it { should be_able_to :cancel_vote, other_answer }
      it { should_not be_able_to :cancel_vote, his_answer }
    end


    # Attachments
    it { should be_able_to :destroy, his_question.attachments.build }
    it { should_not be_able_to :destroy, other_question.attachments.build }
  end
end
