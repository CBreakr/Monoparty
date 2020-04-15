class SpacesController < ApplicationController
    def index 
        @spaces = Space.all 
    end 

    def show 
        @space = Space.find(params[:id])
    end 
end
