define [
  './model'
], (
  ProgramPreset
) ->

  class ProgramPresetsCollection extends Backbone.Collection

    type: 'ProgramPresets'

    model: ProgramPreset

    url: '/program_presets'
