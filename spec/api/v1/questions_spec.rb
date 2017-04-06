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
    let(:questions) { create_list(:question,2) }

    it 'returns 200 status' do
      #get '/api/v1/questions', params: { access_token: access_token.token}, as: :json
      get '/api/v1/questions', format: :json, access_token: access_token.token
      expect(response).to be_success
    end

    it 'return list of questions' do
      expect(response.body).to have_json_size(2)
    end


  end
end
