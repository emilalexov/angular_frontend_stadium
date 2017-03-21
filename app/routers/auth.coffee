define [
  'query-string'

  'views/auth/auth-view'
  'views/auth/forgot-password-view'
  'features/signup/view'
  'views/auth/reset-password-view'
  'views/auth/confirm-registration-view'
  'views/auth/resend-confirmation-view'
  'features/payment/trial_ended/view'
  'features/signup/client_reg_select/view'
  'features/signup/pro_invite/view'
  'features/signup/pro_invite_success/view'
  'features/signup/pro_invite_reminder/view'
  'features/signup/waiting_gymcloud_pro/view'
  'features/signup/find_a_pro/view'

  'models/auth/confirm-registration-model'
  'models/auth/resend-confirmation-model'
  'models/auth/reset-password-model'
  'features/signup/model'
  'features/current_user/model'
], (
  QueryString

  AuthView
  ForgotPasswordView
  SignUpView
  ResetPasswordView
  ConfirmRegistrationView
  ResendConfirmationView
  TrialEndedView
  ClientRegSelect
  ProInviteView
  ProInviteSuccessView
  ProInviteReminderView
  WaitingGymcloudPro
  FindPro

  ConfirmRegistrationModel
  ResendConfirmationModel
  ResetPasswordModel
  AccountModel
  CurrentUser
) ->

  class Router extends Marionette.AppRouter

    appRoutes:
      'login': 'login'
      'logout':'logout'
      'signup': 'signUp'
      'signup?*queryString': 'signUp'
      'forgot-password': 'forgotPassword'
      'resend_confirmation': 'resendConfirmation'
      'reset/:token': 'resetPassword'
      'confirm/:token': 'confirmRegistration'
      'trial_ended': 'trialEnded'
      'auth/client_signup': 'clientRegSelect'
      'auth/pro_invite': 'proInvite'
      'auth/pro_invite_success': 'proInviteSuccess'
      'auth/pro_invite_reminder': 'proInviteReminder'
      'auth/waiting_gymcloud_pro': 'waitingGymcloudPro'
      'auth/find_a_pro': 'findPro'

  class Controller extends Marionette.Controller

    login: (signUp) =>
      if App.request('accessToken:get')
        return App.vent.trigger('redirect:to', '#')

      view = new AuthView
        signUp: signUp
      @_showView(view)

    logout: ->
      App.request('accessToken:remove')
      App.request('data:all:clear')
      App.request('current_user:reset')
      App.vent.trigger('mixpanel:sign_out')
      App.vent.trigger('redirect:to', '#login')

    forgotPassword: ->
      view = new ForgotPasswordView
      @_showView(view)

    signUp: (queryString) =>
      if App.request('accessToken:get')
        App.vent.trigger('redirect:to', '#')
        return

      queryParams = QueryString.parse(queryString)
      view = new SignUpView
        model: new AccountModel(queryParams)
      @_showView(view)

    resetPassword: (token) =>
      model = new ResetPasswordModel
      view = new ResetPasswordView
        model: model
        token: token
      @_showView(view)

    confirmRegistration: (token) =>
      view = new ConfirmRegistrationView
        token: token
        model: new ConfirmRegistrationModel
        profileModel: new CurrentUser
      @_showView(view)

    resendConfirmation: =>
      model = new ResendConfirmationModel
      view = new ResendConfirmationView
        model: model
      @_showView(view)

    trialEnded: ->
      view = new TrialEndedView
      @_showView(view)

    clientRegSelect: ->
      @_showView(new ClientRegSelect)

    proInvite: ->
      view = new ProInviteView
      @_showView(view)

    proInviteSuccess: ->
      view = new ProInviteSuccessView
      @_showView(view)

    proInviteReminder: ->
      view = new ProInviteReminderView
      @_showView(view)

    waitingGymcloudPro: ->
      view = new WaitingGymcloudPro
      @_showView(view)

    findPro: ->
      view = new FindPro
      @_showView(view)

    _showView: (view) ->
      App.request 'views:show', view,
        layout: 'auth'
        region: 'content'

  Router: Router
  Controller: Controller
  init: ->
    new Router
      controller: new Controller
