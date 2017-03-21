define [
  './template'
], (
  template
) ->

  class View extends Marionette.LayoutView

    template: template

    className: 'gc-program-video'

    behaviors:

      editable_textarea: true
      video_assigned: true

    ui:
      workoutTabsContent: '.gc-workout-tab-content'

    events:
      'click ul.gc-content-nav li a': '_changeTab'

    onShow: ->
      @listenToOnce @video_assigned, 'show', =>
        @listenTo(@video_assigned.currentView, 'video:assign',
          @_showAssignModal)

    _changeTab: (ev) ->
      tabName = $(ev.currentTarget).data('content')
      @ui.workoutTabsContent.find('.tab-pane.active').removeClass('active')
      @ui.workoutTabsContent.find("[data-pane='#{tabName}']").addClass('active')

    _showAssignModal: ->
      App.request('modal:video:assign', @model)