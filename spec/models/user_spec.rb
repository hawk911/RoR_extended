require 'rails_helper'

RSpec.describe User, type: :model do
  context 'validate' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
  end

  context 'association' do
    it { should have_many(:questions) }
    it { should have_many(:answers) }
  end

  context 'subscription' do
    it { should have_many(:subscriptions).dependent(:destroy) }
    it { should have_many(:subscribed_questions).through(:subscriptions).source(:question) }
  end

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '1234567890') }
    context 'user alredy has authorization' do
      it 'return the user' do
        user.authorizations.create(provider: 'facebook', uid: '1234567890' )
        expect(User.find_for_oauth(auth)).to eq user
      end
    end
    context 'user has not authorization' do
      context 'user alredy exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '1234567890', info: { email: user.email }) }
        it 'does not create new user' do
          expect{User.find_for_oauth(auth)}.to_not change(User,:count)
        end
        it 'creates authorization for user' do
          expect{User.find_for_oauth(auth)}.to change(user.authorizations,:count).by(1)
        end

        it 'create authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq(auth.provider)
          expect(authorization.uid).to eq(auth.uid)
        end

        it 'return the user' do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end
      context 'user does not exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '1234567890', info: { email: 'newprovider@user.com' }) }
        it 'create new user' do
          expect{User.find_for_oauth(auth)}.to change(User,:count).by(1)
        end

        it 'return the user' do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it 'fills user email' do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info[:email]
        end

        it 'create authorization for user' do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it 'create authorization with provider and uid' do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq(auth.provider)
          expect(authorization.uid).to eq(auth.uid)
        end
      end
    end
  end

  describe '#subscribed_to?' do
    let(:subscribed_user) { create(:user) }
    let(:not_subscribed_user) { create(:user) }
    let(:question) { create(:question) }
    let!(:subscription) { create(:subscription, user: subscribed_user, question: question) }

    context 'when user is subscribed' do
      it { expect(subscribed_user).to be_subscribed_to(question) }
    end

    context 'when user is not subscribed' do
      it { expect(not_subscribed_user).to_not be_subscribed_to(question) }
    end
  end
end
