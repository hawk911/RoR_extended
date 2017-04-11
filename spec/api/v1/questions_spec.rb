require 'rails_helper'

describe 'Questions API' do
  describe 'GET #index' do
    let(:url) { '/api/v1/questions' }
    context 'unauthorized' do
      it 'will return 401 if there is no access token' do
        get url,  params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'will return 401 if access token is invalid' do
        get url, params: { access_token:'123456', format: :json }
        expect(response.status).to eq 401
      end
    end


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

  describe 'GET #list' do
    let(:url) { '/api/v1/questions/list' }
    context 'unauthorized' do
      it 'will return 401 if there is no access token' do
        get url,  params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'will return 401 if access token is invalid' do
        get url, params: { access_token:'123456', format: :json }
        expect(response.status).to eq 401
      end
    end

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

      %w(id title created_at updated_at).each do |attr|
        it "question object contains #{attr}" do
          question = questions.first
          expect(response.body).to be_json_eql(question.send(attr.to_sym).to_json).at_path("questions/0/#{attr}")
        end
      end
    end
  end
  describe 'GET #Show' do
	let(:question) { create(:question) }
    let(:url) { "/api/v1/questions/#{question.id}" }
    context 'unauthorized' do
      it 'will return 401 if there is no access token' do
        get url,  params: { format: :json }
        expect(response.status).to eq 401
      end

      it 'will return 401 if access token is invalid' do
        get url, params: { access_token:'123456', format: :json }
        expect(response.status).to eq 401
      end
    end
  end
end
