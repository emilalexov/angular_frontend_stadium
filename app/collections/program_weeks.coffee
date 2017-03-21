define [
  'models/program_week'
], (
  ProgramWeek
) ->

  class ProgramWeeks extends Backbone.Collection

    type: 'ProgramWeeks'

    model: ProgramWeek

    comparator: 'position'
