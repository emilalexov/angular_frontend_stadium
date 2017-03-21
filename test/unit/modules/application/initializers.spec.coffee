define [
  'modules/application/initializers'
], (
  initializers
) ->

  context 'Modules::Application', ->

    describe 'initializers', ->

      before ->
        @it = initializers

      it 'is a function', ->
        expect(@it).to.be.a('function')
