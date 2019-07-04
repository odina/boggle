class Api::BaseController < ActionController::Base
  include HttpAuthConcern
end
