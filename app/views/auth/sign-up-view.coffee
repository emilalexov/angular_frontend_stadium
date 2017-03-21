config = require 'config'

SignUpStep1Model = require 'models/auth/signup-step1-model'
SignUpStep2Model = require 'models/auth/signup-step2-model'
LoginModel = require 'models/auth/login-model'

class SignUpStep1 extends Marionette.ItemView

  template: require('templates/auth/sign-up-1')

  behaviors:

    form_validation: true

  ui:
    types: '.gc-trainer-type'
    radio: '.gc-trainer-type input[type=radio]'
    form: '#gc-signup-step-1'
    emailGroup: '.gc-email-form-group'

  events:
    'change @ui.radio': 'switchType'
    'submit @ui.form': 'submit'

  initialize: =>
    Backbone.Validation.bind @

  switchType: (ev) =>
    if $(ev.currentTarget).is ':checked'
      @ui.types.removeClass 'active'
      $(ev.currentTarget).closest('.gc-trainer-type').addClass 'active'

  submit: (ev) =>
    formData = @ui.form.serializeObject()
    for key, value of formData
      if key is 'trainer-type'
        formData[key] = parseInt value
    @model.set formData
    @model.save @model.attributes,
      wait: true
      success: (data) =>
        loginModel = new LoginModel
          username: @model.get('email')
          password: @model.get('password')
        loginModel.once 'model:login:success', (response) =>
          App.request 'accessToken:set', response.access_token
          App.request('current_user').fetch()
            .done ->
              App.vent.trigger('mixpanel:sign_up')
          @trigger 'next', @model
        loginModel.login()
      error: (model, xhr, error) =>
        errors = xhr.responseJSON.error
        for key, value of errors
          message = value.join(', ')
          input = @ui.form.find("input[name='#{key}']")
          uiGroup = input.parents('.form-group')
          @trigger 'switchError', message , uiGroup

class SignUpStep2 extends Marionette.ItemView

  template: require('templates/auth/sign-up-2')

  behaviors:

    form_validation: true

  ui:
    form: '#gc-signup-step-2'
    dateInputFroup: '.gc-date-selectors'

  events:
    'submit @ui.form': 'submit'

  initialize: =>
    Backbone.Validation.bind @
    @on 'signup:errors', @returnedErrors

  submit: (ev) =>
    formData = @prepare_attributes @ui.form.serializeObject()
    @model.set formData

    if @model.isValid true
      currentUser = App.request('current_user')
      profile = currentUser.get('user_profile')
      if profile_id = profile?.id
        @model.set 'id', profile_id
        @saveProfile()
      else
        currentUser.fetch().then (model) =>
          profile_id = model.get('user_profile').id
          @model.set 'id', profile_id
          @saveProfile()

  prepare_attributes: (formData)->
    year = formData['birth_year']
    month = formData['birth_month']
    day = formData['birth_day']
    birth = "#{year}-#{month}-#{day}"
    if moment(birth, 'YYYY-MM-DD', true).isValid()
      formData['birthday'] = birth
    else
      @trigger 'switchError', 'Incorrect date', @ui.dateInputFroup
    formData['location'] = [
      formData['state'],
      formData['city'],
      formData['address']
    ].join(', ')
    formData

  saveProfile: ->
    @model.save @model.attributes,
      wait: true
      success: (data) =>
        @trigger 'final', @model
      error: (model, xhr, error) =>
        errors = xhr.responseJSON.error
        for key, value of errors
          message = value.join(', ')
          input = @ui.form.find("input[name='#{key}']")
          uiGroup = input.parents('.form-group')
          @trigger 'switchError', message , uiGroup

  stepBack: (ev) =>
    @trigger 'signup:back'

  returnedErrors: (errors) =>
    for name, error_msg of errors
      $input = @$el.find("input[name=#{name}]")
      $inputGroup = $input.closest('.form-group')
      @trigger 'switchError', error_msg[0], $inputGroup

module.exports = class SignUpView extends Marionette.LayoutView

  template: require('templates/auth/empty_layout')

  regions:
    signUp: '#gc-default-region'

  initialize: =>
    @step1 = new SignUpStep1
      model: new SignUpStep1Model
    @step2 = new SignUpStep2
      model: new SignUpStep2Model
    @listenTo @step1, 'next', @nextStep
    @listenTo @step2, 'final', @final

  onShow: =>
    @signUp.show @step1

  nextStep: (dataStep1) =>
    @steps = dataStep1
    @signUp.show @step2

  final: (dataStep2) =>
    App.vent.trigger ''
    @trigger 'signup:complete'
