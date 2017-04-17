shared_examples_for "API Authenticable" do
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
