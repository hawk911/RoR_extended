require 'rails_helper'

RSpec.describe AnswersController, type: :controller do

  let(:question) { create(:question)  }
  let(:answer) { create(:answer, question: question) }

  describe 'GET #new' do
    sign_in_user
    before {get :new, params: { question_id: question } }

    it 'assigns a new answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user

    context 'with validate attributes' do
      it 'saves the new answer in the base' do
        expect { post :create, params: {question_id: question, answer: attributes_for(:answer)} }.to change(question.answers, :count).by(1)
      end

      it 'redirects to show view' do
        post :create, params: {question_id: question, answer: attributes_for(:answer)}
        expect(response).to redirect_to assigns(:question)
      end
    end

    context "create with invalid attributes" do

      it "doesn't save a new answer into the database" do
        expect { post :create, params: {question_id: question, answer: attributes_for(:invalid_answer)}  }.to_not change(Answer, :count)
      end

      it "re-renders new view" do
        post :create, params: {question_id: question, answer: attributes_for(:invalid_answer)}
        expect(response).to render_template :new
      end
end
  end



end
