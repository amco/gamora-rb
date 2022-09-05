class ApplicationController < ActionController::Base
  include Gamora::Authentication::Session

  before_action :authenticate_user!
end
