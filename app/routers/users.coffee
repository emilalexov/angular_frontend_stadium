define [
  'features/new_profile_view/view'
  'pages/users/overview/page'
  'pages/personal_exercises/overview/page'
  'models/user'
], (
  NewProfileView
  OverviewPage
  PersonalExercisePage
  UserModel
) ->

  class Router extends Marionette.AppRouter

    appRoutes:

      'users/me(/)': 'myProfile'
      'users/me/edit': 'editMyProfile'
      'users/:id': 'root'
      'users/:id/edit': 'editUserProfile'
      'users/:id/:state': 'overview'
      'users/:id/exercises/:exercise_id': 'personalExercise'

  class Controller extends Marionette.Controller


    root: (id) ->
      path = ['users', id, 'programs']
      App.vent.trigger('redirect:to', path)

    overview: (id, state) ->
      new OverviewPage
        id: id
        state: state

    myProfile: ->
      user = App.request('current_user')
      @root(user.id)

    editMyProfile: ->
      user = App.request('current_user')
      @_editUserProfile(user.user_profile)

    editUserProfile: (id) ->
      currentUser = App.request('current_user')
      user = currentUser.clients.get(id) or new UserModel(id: id)
      return @_editUserProfile(user.user_profile) unless user.isNew()
      user.fetch()
        .then -> @_editUserProfile(user.user_profile)

    personalExercise: (userId, exerciseId) ->
      currentUser = App.request('current_user')
      user = currentUser.clients.get(userId) or new UserModel(id: userId)
      new PersonalExercisePage
        id: exerciseId
        user: user
        state: 'overview'

    _editUserProfile: (profile) ->
      view = new NewProfileView
        model: profile
      @_showView(view)

    _showView: (view) ->
      App.request('views:show', view)

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller
