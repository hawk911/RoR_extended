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

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    # Create
    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    # Update
    it { should be_able_to :update, create(:question, user: user) }
    it { should_not be_able_to :update, create(:question, user: other_user) }

    it { should be_able_to :update, create(:answer, user: user) }
    it { should_not be_able_to :update, create(:answer, user: other_user) }

    it { should be_able_to :update, create(:comment, user: user) }
    it { should_not be_able_to :update, create(:comment, user: other_user) }

    # Destroy
    it { should be_able_to :destroy, his_question }
    it { should_not be_able_to :destroy, other_question }

    it { should be_able_to :destroy, his_answer }
    it { should_not be_able_to :destroy, other_answer }

    # Set best answer
    it { should be_able_to :set_best, create(:answer, question: his_question) }
    it { should_not be_able_to :set_best, create(:answer, question: other_question) }

     # Votes
    it { should be_able_to :vote_up, other_question }
    it { should_not be_able_to :vote_up, his_question }

    it { should be_able_to :vote_down, other_question }
    it { should_not be_able_to :vote_down, his_question }

    it { should be_able_to :vote_up, create(:answer) }
    it { should_not be_able_to :vote_up, his_answer }

    it { should be_able_to :vote_down, create(:answer) }
    it { should_not be_able_to :vote_down, his_answer }

    # Attachments
    it { should be_able_to :destroy, his_question.attachments.build }
    it { should_not be_able_to :destroy, other_question.attachments.build }
  end
end
