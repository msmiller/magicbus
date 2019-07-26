/*
* @Author: msmiller
* @Date:   2019-07-25 16:28:34
* @Last Modified by:   msmiller
* @Last Modified time: 2019-07-25 17:01:21
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

  });

  console.log("-=> commands_controller loaded");

})()
