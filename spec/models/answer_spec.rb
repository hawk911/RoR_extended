require 'rails_helper'

RSpec.describe Answer, type: :model do
  context 'validate' do
    it { should validate_presence_of :body }
    it { should validate_presence_of :question_id }
    it { should validate_presence_of :user_id }
  end

  context 'association' do
    it { should belong_to(:question) }
    it { should belong_to(:user) }
    it { should have_many(:attachments).dependent(:destroy) }
  end

  context 'have index' do
    it { should have_db_index :question_id }
    it { should have_db_index :user_id }
  end

  context 'attachments' do
    it { should accept_nested_attributes_for :attachments }
  end

  describe '#set_best method' do
    let(:question_and_answer) { create(:question_with_answers) }
    let(:answer_first) { question_and_answer.answers.first }
    let(:answer_last) { question_and_answer.answers.last }
    let!(:answer_best) { create(:answer, best: true) }

    it 'answer toggled the best' do
      expect { answer_first.toggle_best! }.to change { answer_first.best }.from(false).to(true)
    end

    it 'only one answer the best' do
      answer_first.toggle_best!
      expect(answer_last).to_not be_best
    end

    it 'answer toggled revers the best' do
      expect { answer_best.toggle_best! }.to change { answer_best.best }.from(true).to(false)
    end
  end

  it_behaves_like 'votable'
end
