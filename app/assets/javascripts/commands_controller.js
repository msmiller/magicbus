/*
* @Author: msmiller
* @Date:   2019-07-25 16:28:34
* @Last Modified by:   msmiller
* @Last Modified time: 2019-07-26 12:43:28
*
* Copyright (c) 2017-2018 Sharp Stone Codewerks / Mark S. Miller
*/

(() => {
  stimulus.register("commands", class extends Stimulus.Controller {

  connect() {
    console.log("-=> commands_controller connected");
  }

  disconnect() {
  }

  send_to_all() {
    $.post( '/broadcast', { 'channel' : '#magicbus',
                            'message' : 'Sent to everyone on #magicbus',
                            'mode' : 'publish'
    });
  }

  clear_logs() {
    $.post( '/broadcast', { 'channel' : '#magicbus',
                            'message' : 'clearlogs',
                            'mode' : 'publish'
    });
  }

  rpc_demo() {
    $.post( '/broadcast', { 'channel' : '@lyrics',
                            'message' : 'Sent rpc to @lyrics',
                            'mode' : 'publish_rpc'
    });
  }

  three_lines() {
    $.post( '/broadcast', { 'channel' : '@lyrics',
                            'message' : 'get_three_lines',
                            'mode' : 'publish_rpc'
    });
  }

  cache_thru() {
    $.post( '/broadcast', { 'channel' : '@albums',
                            'message' : 'get_album_2',
                            'mode' : 'retrieve'
    });
  }

  });

  console.log("-=> commands_controller loaded");

})()
