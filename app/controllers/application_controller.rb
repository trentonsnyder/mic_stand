class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  def render_404
    render file: 'public/404.html', status: :not_found, layout: false
  end
end
