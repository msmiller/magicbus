class HomeController < ApplicationController
  def index
  end

  def buslog
    @bus_log = $buslog.values.reverse
    # render json: @bus_log.reverse
    render layout: false
  end

  def broadcast
  end
end
