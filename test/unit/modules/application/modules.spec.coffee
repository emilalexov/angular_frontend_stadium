define [
  'modules/application/modules'
], (
  modules
) ->

  context 'Modules::Application', ->

    describe 'modules', ->

      before ->
        @it = modules

      it 'is a function', ->
        expect(@it).to.be.a('function')
