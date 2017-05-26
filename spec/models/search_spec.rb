require 'rails_helper'

RSpec.describe Search, type: :sphinx do

  describe 'get_results' do
    it "return search_types" do
      expect(described_class::CONTEXTS).to eq %w(Questions  Answers  Comments  Users)
    end

    it 'should return nil if empty query' do
     expect(Search.get_results(' ', 'Questions')).to be_nil
    end

    it 'receive data' do
      query = "lalalalend"
      data = ThinkingSphinx::Query.escape(query)
      expect(ThinkingSphinx::Query).to receive(:escape).with(query).and_call_original
      expect(ThinkingSphinx).to receive(:search).with(data)
      Search.get_results(query, "")
    end
  end
end
