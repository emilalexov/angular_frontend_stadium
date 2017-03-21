define [
  'deps/scripts'
], (
) ->

  describe 'dependencies: scripts', ->

    describe 'global variables', ->

      depNames = [
        '$'
        '_'
        'Backbone'
        'Handlebars'
      ]

      depNames.forEach (name) ->
        entity = window[name]

        describe name, ->

          it 'is defined', ->
            expect(entity).not.to.be.undefined

          it 'is an object', ->
            expect(entity).to.be.an.object
