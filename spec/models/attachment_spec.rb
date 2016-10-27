require 'rails_helper'

RSpec.describe Attachment, type: :model do
  context 'association' do
    it { should belong_to(:attachable) }
    it { should validate_presence_of :file }
  end
end
