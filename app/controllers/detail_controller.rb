class DetailsController < ApplicationController

    def index
      @tag = query.fetch(:tags, 'all')
      @details, @errors = Picup::Detail.find(query)
    end
  
    def show
      @detail = Picup::Detail.find(params[:id])
    end
  
    private
    def query
      params.fetch(:query, {})
    end
  end