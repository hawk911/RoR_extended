require 'rails_helper'


RSpec.describe QuestionsController, type: :controller do

  let(:question) { create(:question) }

  describe 'GET#index' do
    let(:questions) {create_list(:question,2) }

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
      get :show, params: {id:question}
    end

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'render show view' do
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    sign_in_user
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    sign_in_user
    before { get :edit, params: {id:question} }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    sign_in_user
    context 'with validate attributes' do
      it 'saves the new question in the base' do
        expect { post :create,
                 params: {question:attributes_for(:question)} }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: {question:attributes_for(:question)}
        expect(response).to redirect_to question_path(assigns(:question))
      end

      it 'redirects to show view and set flash success' do
        post :create, params: { question: attributes_for(:question) }
        expect(response).to redirect_to assigns(:question)
        should set_flash[:notice].to t('flash.success.new_question')
      end
    end

    context 'with invalidate attributes' do
      it 'does not save question' do
        expect { post :create,
                 params: {question:attributes_for(:invalid_question)} }.to_not change(Question, :count)
      end

      it 're-renders new view' do
        post :create, params: {question:attributes_for(:invalid_question)}
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    sign_in_user
    context 'valid attributes' do
      it 'assigns the requested question to @question' do
        patch :update, params: {id:question, question:attributes_for(:question)}
        expect(assigns(:question)).to eq question
      end

      it 'change question attributes' do
        patch :update, params: {id:question, question:{title: 'new title', body: 'new body'}}
        question.reload
        expect(question.title).to eq 'new title'
        expect(question.body).to eq 'new body'
      end

      it 'redirects to update' do
        patch :update, params: {id:question, question:attributes_for(:question)}
        expect(response).to redirect_to question
      end
    end

    context 'with invalidate attributes' do
      before {patch :update, params: {id:question, question:{title: 'new title', body: ''}}}
      it 'does not change attributes question' do
        question.reload
        expect(question.title).to eq 'MyString'
        expect(question.body).to eq 'MyText'
      end

      it 're-renders edit view' do
        expect(response).to render_template :edit
      end
    end
  end

  describe 'DELETE #destroy' do
    sign_in_user
    before { question }

    it "deletes question" do
      expect { delete :destroy, params: {id: question}}.to change(Question, :count).by(-1)
    end

    it 'redirect to index vies' do
      delete :destroy, params: {id: question}
      expect(response).to redirect_to questions_path
    end
  end

end
