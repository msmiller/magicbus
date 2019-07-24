/*
* @Author: Mark Miller
* @Date:   2018-08-29 23:12:42
* @Last Modified by:   Mark Miller
* @Last Modified time: 2018-08-29 23:20:01
*
* Copyright (c) 2017-2018 Sharp Stone Codewerks / Mark S. Miller
*/

// via: https://medium.com/cedarcode/installing-stimulus-js-in-a-rails-app-c8564ba51ea2

//= require stimulus.umd

(() => {
  if (!("stimulus" in window)) {
    window.stimulus = Stimulus.Application.start();
    console.log("-=> stimulus loaded");
  }
})()
