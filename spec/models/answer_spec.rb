require 'rails_helper'

RSpec.describe Answer, type: :model do

  let(:answer) { create(:answer) }

  it { should validate_presence_of :body }
  it { should validate_presence_of :question_id }
  it { should belong_to :question }
end
