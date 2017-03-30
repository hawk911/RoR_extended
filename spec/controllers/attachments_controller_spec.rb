require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:another_user) { create :user }
  let!(:question) { create(:question, user: another_user) }
  let!(:question_file) { create(:question_attachment) }
  describe 'Questions' do
    describe 'DELETE #Destroy' do
      context 'author answer' do
        sign_in_user
        before do
          attachable = question_file.attachable
          attachable.update user: @user
          question_file.reload
        end

        it 'destroy question_file' do
          expect { delete :destroy, format: :js, params: { id: question_file.id } }.to change(Attachment, :count).by(-1)
        end
      end

      context 'non-author answer' do
        sign_in_user

        it 'not destroy question_file' do
          expect { delete :destroy, format: :js, params: { id: question_file.id } }.to_not change(Attachment, :count)
        end
      end
    end
  end

  describe 'Answers' do
    let!(:answer) { create(:answer, question: question, user: another_user) }
    let!(:answer_file) { create(:attachment, attachable: answer) }
    describe 'DELETE #Destroy' do
      context 'author answer' do
        sign_in_user
        before do
          attachable = answer_file.attachable
          attachable.update user: @user
          answer_file.reload
        end

        it 'deletes files' do
          expect { delete :destroy, format: :js, params: { id: answer_file } }.to change(answer.attachments, :count).by(-1)
        end
      end

      context 'non-author answer' do
        it 'try to delete answer file' do
          expect { delete :destroy, format: :js, params: { id: answer_file } }.not_to change(Attachment, :count)
        end
      end
    end
  end
end
