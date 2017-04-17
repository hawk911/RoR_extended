require 'rails_helper'
require Rails.root.join('spec/api/v1/concerns/api_authorization')
require Rails.root.join('spec/api/v1/concerns/api_commentable')
require Rails.root.join('spec/api/v1/concerns/api_attachable')

describe 'Answers API' do
  let!(:question) { create(:question) }
  describe 'GET #index' do
    let(:url) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like "API Authenticable"


    context 'authorized' do
      let!(:answers) { create_list(:answer, 2, question: question) }
      let!(:first_answer) { answers.first }
      let(:access_token) { create(:access_token) }

      before do
        get url, params: { access_token: access_token.token, format: :json }
      end

      it 'returns 200 status' do
        expect(response).to be_success
      end

      it 'return list of answers' do
        expect(response.body).to have_json_size(2).at_path("answers")
      end

      %w(id body created_at updated_at user_id question_id).each do |attr|
        it "answer object contains #{attr}" do
          answer = answers.first
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answers/0/#{attr}")
        end
      end
    end
  end

  describe 'GET #show' do
    let!(:answer) { create(:answer, question: question) }
    let!(:comments) { create_list(:comment, 2, commentable: answer) }
    let!(:attachments) { create_list(:attachment, 2, attachable: answer) }
    let(:url) { "/api/v1/answers/#{answer.id}" }
    it_behaves_like "API Authenticable"

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      before do
        get url, params: { access_token: access_token.token, format: :json }
      end

      it 'returns 200 status code' do
        expect(response.status).to eq 200
      end

      it 'returns the answers' do
        expect(response.body).to have_json_size(1)
      end

      %w(id body created_at updated_at user_id question_id).each do |attr|
        it "answer object contains #{attr}" do
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("answer/#{attr}")
        end
      end

      it_behaves_like "API Commentable", :answer
      it_behaves_like "API Attachable", :answer
    end
  end

  describe 'POST #create' do
    let(:url) { "/api/v1/questions/#{question.id}/answers" }

    it_behaves_like "API Authenticable"

    context 'authorized and post valid data' do
      let(:access_token) { create(:access_token) }
      let(:params) do
        {
          answer:       { body: 'New answer' },
          question_id:  question.id,
          access_token: access_token.token,
          format:       :json
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
          answer:       { body: nil },
          question_id:  question.id,
          access_token: access_token.token,
          format:       :json
        }
      end

      before do
        post url, params: params
      end

      it 'returns 422 status code' do
        expect(response.status).to eq 422
      end

      it 'returns errors' do
        expect(response.body).to have_json_size(1).at_path("errors/body")
      end
    end
  end
end
