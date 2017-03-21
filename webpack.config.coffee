path = require('path')
webpack = require('webpack')
autoprefixer = require('autoprefixer')
ExtractTextPlugin = require('extract-text-webpack-plugin')

require('dotenv').load()

module.exports =

  cache: true
  debug: true
  devtool: '#source-map'

  context: path.resolve('app')

  entry:
    main: 'app'
    pre: 'pre'

  output:
    path: path.resolve('build')
    publicPath: 'build/'
    filename: '[name].js'
    chunkFilename: '[id].js'

  resolve:

    root: [
      path.resolve('app')
      path.resolve('.')
      path.resolve('bower_components')
    ]

    alias:
      'config':
        path.join(__dirname, 'config', process.env.NODE_ENV || 'test')
      'selectize':
        'app/deps/vendor/selectize.js'
      'spinner':
        'bower_components/spin.js/spin.js'
      'datetimepicker':
        'bower_components/eonasdan-bootstrap-datetimepicker' +
          '/src/js/bootstrap-datetimepicker'
      'messenger':
        'bower_components/messenger/build/js/messenger.js'
      'bootstrap':
        'bower_components/bootstrap/dist/js/bootstrap.js'
      'backbone_original':
        'node_modules/backbone/backbone.js'
      'marionette_original':
        'node_modules/backbone.marionette' +
          '/lib/core/backbone.marionette.js'
      'jquery_original':
        'node_modules/jquery/dist/jquery.js'
      'marionette':
        'deps/bundles/marionette/bundle'
      'moment_original':
        'node_modules/moment/moment.js'
      'moment':
        'deps/bundles/moment/original'
      'jquery.ui.widget':
        'bower_components/blueimp-file-upload' +
          '/js/vendor/jquery.ui.widget.js'
      'jquery-iframe-transport':
        'bower_components/blueimp-file-upload' +
          '/js/jquery.iframe-transport.js'
      'load-image':
        'bower_components/blueimp-load-image' +
          '/js/load-image.js'
      'tmpl':
        'bower_components/blueimp-tmpl/js/tmpl.min.js'
      'jquery-file-upload':
        'bower_components/blueimp-file-upload/js/jquery.fileupload.js'
      'jquery-file-upload-process':
        'bower_components/blueimp-file-upload/js/jquery.fileupload-process.js'
      'jquery-file-upload-video':
        'bower_components/blueimp-file-upload/js/jquery.fileupload-video.js'
      'jquery-file-upload-validate':
        'bower_components/blueimp-file-upload/js/jquery.fileupload-validate.js'
      'jquery-file-upload-ui':
        'bower_components/blueimp-file-upload/js/jquery.fileupload-ui.js'
      'owl-carousel':
        'bower_components/owl-carousel/owl-carousel/owl.carousel.js'
      'custom-scroll':
        'node_modules/jquery.nicescroll/jquery.nicescroll.js'

    extensions: [
      ''
      '.webpack.js'
      '.web.js'
      '.js'
      '.json'
      '.coffee'
      '.jade'
      '.hbs'
      '.scss'
      '.styl'
      '.css'
    ]

  module:

    noParse: /\.min\.js/

    loaders: [
      {
        test: /\.coffee$/
        loader: 'coffee'
      }
      {
        test: /\.json/
        loader: 'json'
      }
      {
        test: /\.hbs$/
        loader: 'handlebars'
        query:
          runtime: 'handlebars/runtime'
          #inlineRequires: 'app/images/'
          helperDirs: [
            __dirname + '/app/handlers/handlebars'
          ]
      }
      {
        test: /\.jade$/
        loader: 'jade'
      }
      {
        test: /\.css$/
        # loader: 'style!css'
        loader:
          ExtractTextPlugin.extract(
            'style-loader?sourceMap',
            'css-loader?sourceMap',
            publicPath: ''
          )
      }
      {
        test: /\.styl$/
        # loader: 'style!css!stylus'
        loader:
          ExtractTextPlugin.extract(
            'style-loader?sourceMap',
            'css-loader?sourceMap!postcss-loader!stylus-loader?sourceMap',
            publicPath: ''
          )
      }
      {
        test: /\.scss$/
        loader: 'style!css!sass?outputStyle=expanded&' + \
          # 'includePaths[]=' + (path.resolve('bower_components')) + '&' + \
          'includePaths[]=' + (path.resolve('node_modules'))
      }
      {
        test: /\.otf/
        loader: 'file?prefix=font/&mimetype=application/x-font-opentype'
      }
      {
        test: /\.eot/
        loader: 'file?prefix=font/&mimetype=application/vnd.ms-fontobject'
      }
      {
        test: /\.ttf/
        loader: 'file?prefix=font/&mimetype=application/x-font-truetype'
      }
      {
        test: /\.svg/
        loader: 'file?prefix=font/&mimetype=image/svg+xml'
      }
      {
        test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/
        loader: 'file?prefix=font/&mimetype=application/font-woff'
      }
      {
        test: /\.png$/
        loader: 'file?prefix=img/&mimetype=image/png'
      }
      {
        test: /\.jpg$/
        loader: 'file?prefix=img/&mimetype=image/jpg'
      }
      {
        test: /\.gif$/
        loader: 'file?prefix=img/&mimetype=image/gif'
      }
    ]

  postcss: ->
    [autoprefixer]

  externals: {}

  plugins: [
      new webpack.ProvidePlugin(
        $:
          'deps/bundles/jquery/original'
        jQuery:
          'deps/bundles/jquery/original'
        'window.jQuery':
          'deps/bundles/jquery/original'
        _:
          'deps/bundles/underscore/bundle'
        Backbone:
          'deps/bundles/backbone/original'
        Marionette:
          'deps/bundles/marionette/original'
        moment:
          'deps/bundles/moment/bundle'
        can:
          'deps/bundles/can'
        feature:
          'features/feature/factory'
      )
    ,
      new ExtractTextPlugin('[name].css')
    ,
      new webpack.ResolverPlugin(
        new webpack.ResolverPlugin
          .DirectoryDescriptionFilePlugin('bower.json', ['main'])
      )
  ]

  node:
    fs: 'empty'
