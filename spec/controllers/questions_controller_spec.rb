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
    before { get :new }

    it 'assigns a new Question to @question' do
      expect(assigns(:question)).to be_a_new(Question)
    end

    it 'render new view' do
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do

    before do
      get :edit, params: {id:question}
    end

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'render edit view' do
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context 'with validate attributes' do
      it 'saves the new question in the base' do
        expect { post :create, params: {question:attributes_for(:question)} }.to change(Question, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: {question:attributes_for(:question)}
        expect(response).to redirect_to	question_path(assigns(:question))
      end

    end

  end

end
