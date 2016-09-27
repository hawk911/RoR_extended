require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  let(:answer) { create(:answer, question: question) }
  let(:user) { create :user }

  describe 'POST #create' do
    sign_in_user

    context 'with validate attributes' do
      it 'saves the new answer in the base' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question_id: question, answer: attributes_for(:answer) }
        expect(response).to redirect_to assigns(:question)
      end

      it 'user owned answer' do
        expect { post :create, params: { answer: attributes_for(:answer), question_id: question.id } }.to change(@user.answers, :count).by(1)
      end
    end

    context 'create with invalid attributes' do
      it 'does not save a new answer into the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:invalid_answer) } }.to_not change(Answer, :count)
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
end
