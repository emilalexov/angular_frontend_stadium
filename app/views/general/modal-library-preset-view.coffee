module.exports = class LibraryPresetModalView extends Marionette.ItemView

  template: require('templates/general/library-preset-modal')

  className: 'modal-dialog'

  initialize: ->
    @currentIndex = 0

  ui:
    initializePreset: 'a.gc-initialize-preset'
    rejectPreset: 'a.gc-reject-preset'
    presetSteps: '.gc-step'
    savePreset: 'a.gc-save-preset'
    nextButton: 'a.next-button'
    previousButton: 'a.previous-button'

  events:
    'click @ui.nextButton': 'onNext'
    'click @ui.previousButton': 'onPrevious'

  onNext: (ev) ->
    @ui.presetSteps[@currentIndex].classList.remove 'active'
    @ui.presetSteps[@currentIndex += 1].classList.add 'active'

  onPrevious: (ev) ->
    @ui.presetSteps[@currentIndex].classList.remove 'active'
    @ui.presetSteps[@currentIndex -= 1].classList.add 'active'
