require 'rails_helper'

RSpec.describe Attachment, type: :model do
  context 'association' do
    it { should belong_to(:question) }
    #it { should belong_to(:answer) }
  end
end
