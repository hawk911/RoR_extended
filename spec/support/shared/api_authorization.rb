shared_examples_for 'API Authenticable' do
  context 'unauthorized' do

    options ||= {}
    http_method ||= :get

    it 'will return 401 if there is no access token' do
      do_request(url, http_method, options)
      expect(response.status).to eq 401
    end

    it 'will return 401 if access token is invalid' do
      do_request(url, http_method, options.merge(access_token: '123456'))
      expect(response.status).to eq 401
    end
  end
end
