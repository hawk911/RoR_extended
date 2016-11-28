require 'rails_helper'
require Rails.root.join('spec/controllers/concerns/voted_spec.rb')

RSpec.describe AnswersController, type: :controller do
  let!(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }
  let(:user) { create :user }
  let(:other_user) { create :user }
  let(:answer_user) { create(:answer, question: question, user: user) }

  describe 'POST #create' do
    sign_in_user

    context 'with validate attributes' do
      it 'saves the new answer in the base' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js }.to change(question.answers, :count).by(1)
      end

      it 'render update template' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :create
      end

      it 'user owned answer' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question.id }, format: :js }.to change(@user.answers, :count).by(1)
      end
    end

    context 'create with invalid attributes' do
      it 'does not save a new answer into the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) }, format: :js }.to_not change(Answer, :count)
      end
    end
  end

  describe 'Destroy #delete' do
    let!(:question_with_answers) { create(:question_with_answers) }
    let!(:answers) { question_with_answers.answers }
    context 'authenticated user' do
      sign_in_user
      context 'user create and delete answers' do
        let!(:user_answer1) do
          question_with_answers.answers.create! body: 'user answer1', user_id: @user.id
        end
        let!(:user_answer2) do
          question_with_answers.answers.create! body: 'user answer2', user_id: @user.id
        end

        before { delete :destroy, params: { id: user_answer1, question_id: question_with_answers } }

        it 'user destroy your answer' do
          expect { delete :destroy, params: { id: user_answer2, question_id: question_with_answers } }
          .to change(Answer, :count).by(-1)
        end

        it 'redirect to question page' do
          should redirect_to(question_with_answers)
        end

        it 'flash success delete answer ' do
          should set_flash[:notice].to I18n.t('flash.success.delete_answer')
        end
      end

      context 'the user can not delete' do
        before { delete :destroy, params: { id: answers[0], question_id: question_with_answers } }

        it 'the user can not delete not the answer' do
          expect { delete :destroy, params: { id: answers[0], question_id: question_with_answers } }
          .not_to change(Answer, :count)
        end

        it 'redirect to question page' do
          should redirect_to(question_with_answers)
        end

        it 'flash error delete answer' do
          should set_flash[:notice].to(I18n.t('flash.danger.auth_error'))
        end
      end
    end

    context 'no-authenticated user' do
      before { delete :destroy, params: { id: answers[0], question_id: question_with_answers } }

      it 'no-authenticated user can not delete question' do
        expect { delete :destroy, params: { id: answers[0], question_id: question_with_answers } }
        .not_to change(Answer, :count)
      end

      it 'redirect to new user session ' do
        should redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PATCH #update' do
    let!(:answer_attachment) { create(:answer_attachment, attachable: answer_user) }
    before { sign_in user }
    context 'valid attributes' do
      it 'assigns the requested answer to @answer' do
        patch :update, params: { id: answer, question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(assigns(:answer)).to eq answer
      end

      it 'change answer attributes' do
        patch :update, params: { id: answer_user, question_id: question, answer: { body: 'new body' } }, format: :js
        answer_user.reload
        expect(answer_user.body).to eq 'new body'
      end

      it 'deletes attachments' do
        expect {
          patch :update, params: {
            id: answer,
            question_id: question.id,
            answer: {
              body: answer_user.body,
              attachments_attributes: { "0": { _destroy: 1, id: answer_attachment } }
            }
          }
        }.to change(answer_user.attachments, :count).by(-1)
      end

      it 'render update template' do
        patch :update, params: { id: answer_user, question_id: question, answer: attributes_for(:answer) }, format: :js
        expect(response).to render_template :update
      end
    end
  end

  describe 'PATCH #set_best' do
    subject(:set_best) { patch :set_best, format: :js, params: { id: answer_to_user } }
    let!(:user_question) { create(:question, user: user) }
    let!(:answer_to_user) { create(:answer, question: user_question) }
    describe 'owner of the question' do
      before do
        sign_in user
        set_best
      end

      it 'assigns the best answer to @answer' do
        expect(assigns(:answer)).to eq answer_to_user
      end

      it 'should be set best true at @answer' do
        expect(assigns(:answer).best).to eq(true)
      end

      it 'renders set_best template' do
        expect(response).to render_template :set_best
      end
    end

    describe 'not owner of the question' do
      before do
        sign_in other_user
        set_best
      end

      it 'could not make answer the best' do
        answer.reload
        expect(answer).to_not be_best
      end
    end
  end

  it_behaves_like 'voted', 'answer'

end
