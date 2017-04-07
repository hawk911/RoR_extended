require 'rails_helper'

describe 'Questions API' do
  describe 'GET /index' do
    context 'unauthorized' do
      it 'will return 401 if there is no access token' do
        get '/api/v1/questions',  as: :json
        expect(response.status).to eq 401
      end

      it 'will return 401 if access token is invalid' do
        get '/api/v1/questions', params: { access_token:'123456'}, as: :json
        expect(response.status).to eq 401
      end
    end
  end

  context 'authorized' do
    let(:access_token) { create(:access_token) }
    let!(:questions) { create_list(:question,2) }
    let(:question) { questions.first }
    let!(:answer) { create(:answer, question: question) }

    #get '/api/v1/questions', params: { access_token: access_token.token}, as: :json
    before { get '/api/v1/questions', format: :json, access_token: access_token.token }

    it 'returns 200 status' do
      expect(response).to be_success
    end

    it 'return list of questions' do
      expect(response.body).to have_json_size(2).at_path("questions")
    end

    %w(id title created_at updated_at).each do |attr|
      it "question object contains #{attr}" do
        question = questions.first
        expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
      end
    end

    context 'answer' do
      it 'include in question object' do
        expect(response.body).to have_json_size(1).at_path("questions/0/answers")
      end

      %w(id body created_at updated_at).each do |attr|
        it "answer object contains #{attr}" do
          question = questions.first
          expect(response.body).to be_json_eql(answer.send(attr.to_sym).to_json).at_path("questions/0/answers/0/#{attr}")
        end
      end
    end


  end
end
