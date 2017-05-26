class SearchesController < ApplicationController
  authorize_resource class: false

  def show
    @results = Search.get_results(params[:query], params[:context]) if params[:query]
  end
end
