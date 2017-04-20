shared_examples 'voted' do |parameter|
  sign_in_user

  let(:user) { create :user }
  let!(:votable) { create(parameter.underscore.to_sym, user: user) }

  describe 'POST #like' do
    context 'non author' do
      it 'vote count changed by 1' do
        expect { post :like, params: { id: votable }, format: :json }.to change(votable.votes, :count).by(1)
      end

      it 'vote value changed by 1' do
        post :like, params: { id: votable }, format: :json
        expect(votable.votes.last.value).to eq 1
      end
    end

    context 'try to vote twice' do
      before { post :like, params: { id: votable }, format: :json }

      it 'does not change total value' do
        expect { post :like, params: { id: votable }, format: :json }.to_not change(Vote, :count)
      end

      it 'total value still 1' do
        expect(votable.total).to eq 1
      end

      it 'show error message' do
        post :like, params: { id: votable }, format: :json
        expect(JSON.parse(response.body)['alert']).to eq 'Вы не можете голосовать!'
      end
    end
  end
end
