require 'rails_helper'

RSpec.describe Question, type: :model do

  let(:question) { create(:question) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }
  it { should have_many(:answers).dependent(:destroy) }
end
