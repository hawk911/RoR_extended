require 'rails_helper'

RSpec.describe SearchesController, type: :controller do

  describe "GET #show" do
    it "returns http success" do
      get :show
      expect(response).to have_http_status(:success)
    end

    context "with valid params" do
      it_behaves_like "Searchable"

      def do_request
        get :show, params: { context: 'Questions', query: '1234' }
      end
    end

    context "with invalid query" do
      it_behaves_like "Searchable"

      def do_request
        get :show, params: { context: 'Questions', query: '' }
      end
    end
    context "with invalid source" do
      it_behaves_like "Searchable"

      def do_request
        get :show, params: { context: '', query: '1234' }
      end
    end
  end
end
