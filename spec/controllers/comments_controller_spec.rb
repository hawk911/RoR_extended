require 'rails_helper'

describe CommentsController do

  describe 'Comments for questions' do
    describe 'POST #create' do
      sign_in_user

      it_behaves_like 'Comments' do
        let(:commentable) { create(:question) }
        let(:params) { { comment: { body: 'My comment' }, question_id: commentable.id, format: :js } }
      end
    end
  end
end
