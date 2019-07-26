/*
* @Author: msmiller
* @Date:   2019-07-25 16:28:34
* @Last Modified by:   msmiller
* @Last Modified time: 2019-07-25 16:38:53
*
* Copyright (c) 2017-2018 Sharp Stone Codewerks / Mark S. Miller
*/

(() => {
  stimulus.register("logs", class extends Stimulus.Controller {

  connect() {
    console.log("-=> logs_controller connected");
    this.load()
    if (this.data.has("refreshInterval")) {
      this.startRefreshing()
    }
  }

  disconnect() {
    this.stopRefreshing();
  }

  load() {
    fetch(this.data.get("url"))
      .then(response => response.text())
      .then(html => {
        this.element.innerHTML = html
      })
  }

  startRefreshing() {
    this.pingerTimer = setInterval(() => {
      this.load()
    }, this.data.get("refreshInterval"))
  }

  stopRefreshing() {
      if (this.pingerTimer) {
        clearInterval(this.pingerTimer)
      }
    }

  });

  console.log("-=> logs_controller loaded");

})()
