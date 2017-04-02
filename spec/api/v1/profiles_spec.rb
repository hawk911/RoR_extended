require 'rails_helper'

describe 'Profile API' do
  describe 'GET /me' do
    context 'unauthorized' do
      it 'will return 401 if there is no access token' do
        get '/api/v1/profiles/me',  as: :json
        expect(response.status).to eq 401
      end

      it 'will return 401 if access token is invalid' do
        get '/api/v1/profiles/me', params: { access_token:'123456'}, as: :json
        expect(response.status).to eq 401
      end
    end
  end

  context 'authorized' do
    let(:me) { create(:user) }
    let(:access_token) { create(:access_token, resource_owner_id: me.id) }

    #before { get '/api/v1/profiles/me', params: { access_token: access_token.token }, as: :json }

    it 'returns 200 status' do
      expect(response).to be_success
    end

    %w(id email created_at updated_at admin).each do |attr|
      it "contains #{attr}" do
        expect(response.body).to be_json_eql(me.send(attr.to_sym).to_json).at_path(attr)
      end
    end

    %w(password encrypted_password).each do |attr|
      it "does not contain #{attr}" do
        expect(response.body).to_not have_json_path(attr)
      end
    end
  end

end
