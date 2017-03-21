define ->

  class ProgramWeek extends Backbone.Model

    type: 'ProgramWeek'

    urlRoot: '/program_weeks/'

    defaults:
      name: undefined
      program_id: undefined
      position: undefined

    setPosition: (pos) ->
      @save({
        position: pos
        name: "Week #{pos}"
      }, wait: true)
