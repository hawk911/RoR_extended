require 'rails_helper'

RSpec.describe Question, type: :model do
  context 'validate' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
    it { should validate_presence_of :user_id }
  end

  context 'association' do
    it { should belong_to :user }
    it { should have_many(:answers).dependent(:destroy) }
    it { should have_many(:attachments).dependent(:destroy) }
    it { should accept_nested_attributes_for :attachments }
  end

  context 'have index' do
    it { should have_db_index :user_id }
  end

  context 'ordered' do
    let(:user) { create(:user) }
    it 'question orders in reverse' do
      questions = create_list(:question, 2, user: user)
      expect(Question.ordered).to eq questions.reverse
    end
  end

  context 'attachments' do
    it { should accept_nested_attributes_for :attachments }
  end
end
