module.exports = (config) ->

  config.set

    basePath: ''

    client:
      mocha:
        reporter: 'spec'
        ui: 'bdd'

    frameworks: [
      'mocha'
      'sinon-chai'
    ]

    files: [
      'test/**/*.spec.*'
      #'app/**/*.coffee'
    ]

    proxies:
      '/app/images/': 'http://localhost:9876/app/images/'

    preprocessors:
      'test/**/*': [
        'webpack'
      ]
      'app/**/*.coffee': [
        'coffeelint'
      ]

    coffeelint:
      onStart: true
      onChange: true
      options: 'coffeelint.json'
      reporter:
        type: 'default'
        options:
          colorize: true

    webpack: require('./webpack.config')

    webpackMiddleware:
      quiet: true
      noInfo: true
      stats:
        colors: true

    reporters: [
      'spec'
    ]

    port: 9876

    colors: true

    logLevel: config.LOG_INFO

    autoWatch: true

    browsers: [
      'PhantomJS'
    ]

    captureTimeout: 60000

    singleRun: false

    plugins: [
      require('karma-mocha')
      require('karma-chai')
      require('karma-sinon-chai')
      require('karma-spec-reporter')
      require('karma-chrome-launcher')
      require('karma-firefox-launcher')
      require('karma-phantomjs-launcher')
      require('karma-webpack')
      require('karma-coffeelint')
    ]

  return
