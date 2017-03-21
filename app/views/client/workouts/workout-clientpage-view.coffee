WorkoutGlobalOverviewView =
  require 'views/client/workouts/workout_clientpage_overview_view'
WorkoutGlobalVideoView =
  require 'views/trainer/workouts/workout_global_video_view'

module.exports = class WorkoutGlobalView extends Marionette.LayoutView

  template: require('templates/client/workouts/workout_clientpage')

  regions:
    manageRegion: '#workout-manage'

  ui:
    workoutTitle: '.gc-workout-title span'
    innerNav: '.gc-inner-nav'
    innerNavItems: '.gc-inner-nav li'
    innerNavLinks: '.gc-inner-nav li a'
    contentNavItems: '.gc-content-nav li'
    contentNavLinks: '.gc-content-nav li a'
    addToLibraryButton: '.gc-add-to-library-button'
    addNoteButton: '.gc-workout-add-note'

  events:
    'click @ui.innerNavLinks': 'changeOverviewActiveTab'
    'click @ui.contentNavLinks': 'changeActiveTab'

  behaviors: ->

    navigate_back: true

    enter_results_for_new_workout_event:
      id: => @model.id

  onShow: ->
    @changeView 'description'

  changeOverviewActiveTab: (ev) ->
    @changeViewEvent(ev, @ui.innerNavItems)

  changeActiveTab: (ev) ->
    @changeViewEvent(ev, @ui.contentNavItems)

  changeViewEvent: (ev, ui) =>
    navItem = $(ev.currentTarget).parent()
    if not $(navItem).hasClass 'active'
      ui.removeClass 'active'
      $(navItem).addClass 'active'
      navItemView = $(navItem).data 'view'
      @changeView navItemView

  changeView: (navView) =>
    switch navView
      when 'description', 'program'
        @overviewView = new WorkoutGlobalOverviewView model: @model
        @manageRegion.show @overviewView
        @ui.innerNav.show()
      when 'video'
        @videoView = new WorkoutGlobalVideoView model: @model
        @manageRegion.show @videoView
        @ui.innerNav.show()
