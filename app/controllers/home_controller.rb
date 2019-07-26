class HomeController < ApplicationController

  def index
  end

  def buslog
    @bus_log = $buslog.values.reverse
    # render json: @bus_log.reverse
    render layout: false
  end

  def broadcast

    if params['message'] == 'clearlogs'
      $buslog.clear
    end

    if params['mode'] == 'publish'
      MagicBus.publish(params['channel'], { 'message' => params['message'] } )
    elsif params['mode'] == 'publish_rpc'
      result = MagicBus.publish_rpc(params['channel'], { 'message' => params['message'] } )
      buslogger("result : #{result.to_s}")
    elsif params['mode'] == 'retrieve'
      result = MagicBus.retrieve('Album', 2, params['channel'], (Time.now + 30.seconds).to_i)
      buslogger("Album.2 : #{result.to_s}")
    end
    # redirect_to "/"
    render plain: 'ok'
  end
end
