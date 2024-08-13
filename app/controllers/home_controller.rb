class HomeController < ApplicationController
  before_action :authenticate_user!


  def index
    return render json: { message: 'devise integration!' }
  end
end
