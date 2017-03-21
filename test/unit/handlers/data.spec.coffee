define [
  'app/handlers/data'
], (
  dataHandler
) ->

  describe 'handlers: data', ->

    before ->
      App = new Marionette.Application
      App.addInitializer ->
        dataHandler(this)
      App.start()
      @subject = App

    it 'can answer on request', ->
      expect(@subject).to.respondTo('request')

    it.skip 'has container data property', ->
      expect(@subject).to.have.property('data')
        .that.is.an('object')
