require 'rails_helper'
require Rails.root.join('spec/api/v1/concerns/api_authorization')
require Rails.root.join('spec/api/v1/concerns/api_commentable')
require Rails.root.join('spec/api/v1/concerns/api_attachable')

describe 'Questions API' do
  describe 'GET #index' do
    let(:url) { '/api/v1/questions' }

    it_behaves_like "API Authenticable"


    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question,2) }
      let(:question) { questions.first }
      let!(:answer) { create(:answer, question: question) }

      before do
        get url, params: { access_token: access_token.token, format: :json }
      end

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'return list of questions' do
        expect(response.body).to have_json_size(2).at_path("questions")
      end

      %w(id title body user_id created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          question = questions.first
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end

      context 'answer' do
        it 'include in question object' do
          expect(response.body).to have_json_size(1).at_path("questions/0/answers")
        end

        %w(id body user_id created_at updated_at).each do |attr|
          it "answer object contains #{attr}" do
            question = questions.first
            expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
          end
        end
      end
    end
  end

  describe 'GET #list' do
    let(:url) { '/api/v1/questions/list' }
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question,2) }
      let(:question) { questions.first }

      before do
        get url, params: { access_token: access_token.token, format: :json }
      end

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'return list of questions' do
        expect(response.body).to have_json_size(2).at_path("questions")
      end

      %w(id title body user_id created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          question = questions.first
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end
    end
  end
  describe 'GET #show' do
    let(:question) { create(:question, created_at: 2.days.ago) }
    let!(:comments) { create_list(:comment, 2, commentable: question) }
    let!(:attachments) { create_list(:attachment, 2, attachable: question) }
    let(:url) { "/api/v1/questions/#{question.id}" }
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      before do
        get url, params: { access_token: access_token.token, format: :json }
      end

      it 'returns 200 status code' do
        expect(response.status).to eq 200
      end

      it 'returns the question' do
        expect(response.body).to have_json_size(1)
      end

      %w(id title body user_id created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("question/#{attr}")
        end
      end

      it_behaves_like "API Commentable", :question
      it_behaves_like "API Attachable", :question
    end
  end

  describe 'POST #create' do
    let(:url) { "/api/v1/questions/" }

    it_behaves_like "API Authenticable"

    context 'authorized and post valid data' do
      let(:access_token) { create(:access_token) }
      let(:params) do
        {
          question:     { title: 'New question title', body: 'New question body' },
          access_token: access_token.token,
          format:      :json
        }
      end

      before do
        post url, params: params
      end

      it 'returns 201 status code' do
        expect(response.status).to eq 201
      end
    end

    context 'authorized and post invalid data' do
      let(:access_token) { create(:access_token) }
      let(:params) do
        {
          question:     { title: 'Question title', body: nil },
          access_token: access_token.token,
          format:      :json
        }
      end

      before do
        post url, params: params
      end

      it 'returns 422 status code' do
        expect(response.status).to eq 422
      end

      it 'returns errors' do
        expect(response.body).to have_json_size(2).at_path("errors/body")
      end

    end
  end
end
