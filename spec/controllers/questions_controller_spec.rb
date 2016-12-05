require 'rails_helper'
require Rails.root.join('spec/controllers/concerns/voted_spec.rb')

RSpec.describe QuestionsController, type: :controller do
  let(:question) { create(:question) }
  let(:user) { create :user }
  let(:question_user) { create(:question, user: user) }

  describe 'GET#index' do
    let(:questions) { create_list(:question, 2) }

    before { get :index }

    it 'status 200' do
      expect(response.status).to eq 200
    end

    it 'populates an array of all question' do
      expect(assigns(:questions)).to match_array(questions)
    end

    it 'renders index view' do
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    before do
      get :show, params: { id: question }
    end

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'render show view' do
      expect(response).to render_template :show
    end

    it 'show answer attachments' do
      expect(assigns(:answer).attachments.first).to be_a_new(Attachment)
    end
  end

  describe 'GET #new' do
    before do
      sign_in user
      get :new
    end

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'assigns new attachment for question' do
      expect(assigns(:question).attachments.first).to be_a_new(Attachment)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    before { sign_in user }
    context 'with validate attributes' do
      it 'saves the new question in the base' do
        expect do
          post :create,
               params: { question: attributes_for(:question) }
        end.to change(Question, :count).by(1)
      end

      it 'user owned question' do
        expect { post :create, params: { question: attributes_for(:question) } }.to change(user.questions, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to question_path(assigns(:question))
      end

      it 'redirects to show view and set flash success' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
        should set_flash[:notice].to I18n.t('flash.success.new_question')
      end
    end

    context 'with invalidate attributes' do
      it 'does not save question' do
        expect do
          post :create,
               params: { question: attributes_for(:invalid_question) }
        end.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: { question: attributes_for(:invalid_question) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before { sign_in user }
    context 'valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: { id: question, question: attributes_for(:question) }, format: :js
        expect(assigns(:question)).to eq question
      end

      it 'change question attributes' do
        patch :update, params: { id: question_user, question: { title: 'edit title', body: 'edit body' } }, format: :js
        question_user.reload
        expect(question_user.title).to eq 'edit title'
        expect(question_user.body).to eq 'edit body'
      end

      it 'render update template' do
        patch :update, params: { id: question_user, question: attributes_for(:question) }, format: :js
        expect(response).to render_template :update
      end
    end

    context 'with invalidate attributes' do
      before { patch :update, params: { id: question, question: { title: 'new title', body: '' } } }
      it 'does not change attributes question' do
        expect(assigns(:question)).to_not receive :update
      end
    end
  end

  describe 'DELETE #destroy' do
    describe 'owner the question' do
      before { sign_in question.user }

      it 'deletes question' do
        expect { delete :destroy, params: { id: question } }.to change(Question, :count).by(-1)
      end

      it 'redirect to index vies' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to questions_path
      end
    end

    describe 'not owner the question' do
      before do
        sign_in user
        question
      end

      it 'could not delete the question' do
        expect { delete :destroy, params: { id: question } }.to_not change(Question, :count)
      end

      it 'redirects to question page' do
        delete :destroy, params: { id: question }
        expect(response).to redirect_to question
      end
    end
  end

  it_behaves_like 'voted', 'question'
end
