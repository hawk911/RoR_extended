require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let!(:file) { create(:question_attachment) }

  describe 'DELETE #Destroy' do
    context 'author answer' do
      sign_in_user
      before do
        attachable = file.attachable
        attachable.update user: @user
        file.reload
      end

      it 'destroy file' do
        expect {delete :destroy, format: :js, params: { id: file.id } }.to change(Attachment, :count).by(-1)
      end
    end

    context 'non-author answer' do
      sign_in_user

      it 'not destroy file' do
        expect {delete :destroy, format: :js, params: { id: file.id } }.to_not change(Attachment, :count)
      end
    end
  end
end
