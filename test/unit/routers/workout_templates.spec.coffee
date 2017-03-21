define [
  'app/routers/workout_templates'
  'backbone'
], (
  Module
  Backbone
) ->

  describe 'Routers::WorkoutTemplates', ->

    describe '#Router', ->

      before ->
        @controller =
          toFolder: sinon.spy()
          root: sinon.spy()
          overview: sinon.spy()
        @it = new Module.Router
          controller: @controller

      it '#superclass', ->
        expect(@it).to.be.an.instanceOf(Marionette.AppRouter)

      it '#appRoutes', ->
        expect(@it.appRoutes).have.all.keys [
          'workout_templates'
          'workout_templates/:id'
          'workout_templates/:id/:state'
        ]

    describe '#Controller', ->

      before ->
        @it = new Module.Controller

      it 'has methods', ->
        expect(@it).to.respondTo('toFolder')
        expect(@it).to.respondTo('root')
        expect(@it).to.respondTo('overview')

    describe '#init', ->

      before ->
        @it = Module.init

      it 'is a function', ->
        expect(@it).to.be.a('function')

      it 'returns router instance', ->
        expect(@it()).to.be.an.instanceOf(Module.Router)
