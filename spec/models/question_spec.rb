require 'rails_helper'

RSpec.describe Question, type: :model do
  context 'validate' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
  end

  context 'association' do
    it { should have_many(:answers).dependent(:destroy) }
  end

  context 'ordered' do
    let(:user) { create(:user) }
    it 'question orders in reverse' do
      questions = create_list(:question, 2, user: user)
      expect(Question.ordered).to eq questions.reverse
    end
  end
end
