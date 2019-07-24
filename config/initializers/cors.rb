#!/usr/bin/ruby
# @Author: msmiller
# @Date:   2019-07-24 12:54:02
# @Last Modified by:   msmiller
# @Last Modified time: 2019-07-24 12:55:31
#
# Copyright (c) 2017-2018 Sharp Stone Codewerks / Mark S. Miller

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'localhost:3000','localhost:3001','localhost:3002','localhost:3003'

    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
