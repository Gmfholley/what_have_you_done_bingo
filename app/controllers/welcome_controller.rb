class WelcomeController < ApplicationController
  skip_before_filter :require_login
  
  def index
    render layout: "no_header"
  end
end
