define [
  'modules/application/class'
], (
  Application
) ->

  context 'Modules::Application', ->

    describe 'Class', ->

      describe 'prototype', ->

        before ->
          @it = Application::

        it 'public functions', ->
          expect(@it).to.respondTo('start')
          expect(@it).to.respondTo('request')

        it 'private functions', ->
          expect(@it).to.respondTo('_onBeforeStart')
          expect(@it).to.respondTo('_onStart')
          expect(@it).to.respondTo('_onStarted')
          expect(@it).to.respondTo('_initPromises')
          expect(@it).to.respondTo('_initModules')
          expect(@it).to.respondTo('_initLayout')
          expect(@it).to.respondTo('_changeLocaltionHash')
          expect(@it).to.respondTo('_initHistory')
          expect(@it).to.respondTo('_startHistory')
          expect(@it).to.respondTo('_openProgramPresetsLoader')



      describe 'instance', ->

        before ->
          @it = new Application

        it '#superclass', ->
          expect(@it)
            .to.be.an.instanceOf(Marionette.Application)
