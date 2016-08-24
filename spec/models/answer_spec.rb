require 'rails_helper'

RSpec.describe Answer, type: :model do

  context 'validate' do
    it { should validate_presence_of :body }
    it { should validate_presence_of :question_id }
  end

  context 'association' do
    it { should belong_to(:question) }
    it { should belong_to(:user) }
  end

end
