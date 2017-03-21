define [
  './template'
  'features/user_authentications/view'
  './user_account_type/view'
], (
  template
  UserAuthenticationsView
  UserAccountTypeView
) ->

  class NewProfileView extends Marionette.LayoutView

    initialize: ->
      Backbone.Validation.bind(@)

    behaviors: ->
      form_validation: true
      facebook_login:
        isSignup: true
        isLinking: true
        successCallback: @successCallback
      google_login:
        isSignup: true
        isLinking: true
        successCallback: @successCallback
      regioned:
        views: [
          region: 'user_authentications'
          klass: UserAuthenticationsView
        ]

      stickit:
        bindings:
          'input[name="gender"]': 'gender'
          'input[name="weight"]': 'weight'
          'input[name="bodyfat"]': 'bodyfat'
          'input[name="first_name"]': 'first_name'
          'input[name="last_name"]': 'last_name'
          'input[name="location"]': 'location'
          'input[name="zip"]': 'zip'
          'input[name="employer"]': 'employer'
          'input[name="birthday"]': 'birthday'
          'select[name="timezone"]': 'timezone'
          '.name': 'full_name'
          '.height-feet':
            observe: 'height_feet'
            events: ['change', 'cut', 'paste', 'blur']
          '.height-inches':
            observe: 'height_inches'
            events: ['change', 'cut', 'paste', 'blur']
          '.avatar':
            attributes: [
              name: 'style'
              observe: 'avatar'
              onGet: (ava) ->
                if _.any(ava?.large.url)
                  "background-image: url(#{ava.large.url})"
                else
                  'background-image: url(app/images/logo-big.png)'
              ]
          '.profile-fullfillment, .profile-progress-bar':
            visible: ->
              feature.isEnabled('user_profile_progress')
          '.account-and-payment':
            visible: ->
              feature.isEnabled('user_account_type') and
              feature.isEnabled('payments')
          '.account-type, .control-links .change':
            visible: ->
              feature.isEnabled('user_account_type')
          '.mmmoney, .control-links .history':
            visible: ->
              feature.isEnabled('payments')
          '.connected-accounts':
            visible: ->
              @model.id is App.request('current_user').user_profile.id

    className: 'new-profile-view'

    template: template

    ui:
      avatar: '.profile-left-side .avatar'
      submitButton: 'button[type="submit"]'
      avatarInput: 'input[type="file"]'

    events:
      'click @ui.submitButton': '_onFormSubmit'
      'change .upload-avatar': 'showThumbnail'
      'blur input': 'validateInput'
      'change @ui.avatarInput': 'uploadAvatar'
      'click .control-links .change': 'changeAccountType'
      'click .restart-tutorial': '_restartTutorial'

    modelEvents: ->
      'change:timezone': (model, value) ->
        if value is '1'
          App.request('current_user:init:timezone')
      'sync': ->
        App.request('current_user:init:timezone')

    onShow: ->
      @_initSelect2TimeZone()
      $('.gc-main').css('padding-left', '0px')
      $('.gc-main').css('padding-right', '0px')
      $.get("/users/#{@model.get('user_id')}").done (user) ->
        $('input[name="email"]').val(user.email)

    _onFormSubmit: ->
      @model.save()
        .done ->
          App.vent.trigger('mixpanel:userUpdate', App.request('current_user'))

    validateInput: (ev) ->
      $input = $(ev.target)
      input_name = $(ev.target).attr 'name'
      input_value = $(ev.target).val()
      if input_value
        $inputGroup = $input.closest('.form-group')
        error_msg = @model.preValidate input_name, input_value
        @trigger 'switchError', error_msg, $inputGroup

    uploadAvatar: ->
      data = new FormData()
      data.append('avatar', @ui.avatarInput[0].files[0])
      upload = $.ajax
        url: "/user_profiles/#{@model.get('id')}/avatar"
        type: 'PATCH'
        data: data
        cache: false
        dataType: 'file'
        processData: false
        contentType: false
      upload.always =>
        @model.fetch()

    successCallback: (json) =>
      @views.user_authentications.trigger('oauthCreated', json)

    changeAccountType: ->
      view = new UserAccountTypeView

      region = App.baseView.getRegion('modal')
      region.show(view)
      region.$el.modal('show')

      App.listenToOnce view, 'modal:closed', ->
        region.$el.modal('hide')
        region.destroy()

    _restartTutorial: ->
      App.request('tour')
        .restartTour()
        .then ->
          App.request 'messenger:show',
            message: 'Tutorial restarted. You will see tutorial tooltips again.'
            type: 'success'

    _initSelect2TimeZone: ->
      zones = moment.tz.names()
      zones = _.map zones, (zone) ->
        id: zone
        text: zone
      zones.unshift
        id: 1
        text: '--- Auto Detect ---'
      zones.unshift
        id: 0
        text: '--- Select Time Zone ---'
      $('select[name="timezone"]').select2
        data: zones
