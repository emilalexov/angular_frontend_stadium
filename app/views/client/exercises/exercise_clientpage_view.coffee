ExerciseGlobalOverviewView =
  require 'views/client/exercises/exercise_clientpage_overview_view'
Breadcrumbs = require 'features/breadcrumbs/view'
# BreadcrumbsView = require 'views/general/breadcrumbs/breadcrumbs-view'

module.exports = class ExerciseGlobalView extends Marionette.LayoutView

  template: require('templates/client/exercises/exercise_clientpage')

  regions:
    manageRegion: '#exercise-manage'
    breadcrumbsRegion: '#breadcrumbs'

  behaviors:

    navigate_back: true

  initialize: (data) =>
    @breadcrumbs = new Breadcrumbs(model: @model)

  onShow: =>
    overviewView = new ExerciseGlobalOverviewView(model: @model)
    @manageRegion.show(overviewView)
    @breadcrumbsRegion.show(@breadcrumbs)
