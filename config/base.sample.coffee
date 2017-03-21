defaults =
  vendor:
    facebook: app_id: '774894325885277'
    google: client_id: '686822539338-h8pp1erjru867em1h45f7rf0qe0ftpdf.apps.googleusercontent.com'
    stripe: publishable_key: 'pk_test_DahnHI1WWNXx0McT4XZlWFCq'
  api: url: undefined
  mobile: url: undefined
  features:
    sign_up: enabled: true
    exercises: enabled: true
    workout_templates: enabled: true
    program_templates: enabled: true
    workout_exercises: enabled: true
    personal_workouts: enabled: true
    personal_programs: enabled: true
    search_global: enabled: true
    payments: enabled: false
    rating_widget: enabled: false
    user_profile_progress: enabled: false
    user_account_type: enabled: true
    hotjar: enabled: false
    freshdesk_widget: enabled: false
    google_analytics: enabled: false
    tooltips_tour: enabled: true
    mixpanel: enabled: false
    refer_friend: enabled: true

module.exports =

  development: $.extend true, {}, defaults,
    vendor:
      facebook: app_id: '774894325885277'
    google: client_id: '686822539338-h8pp1erjru867em1h45f7rf0qe0ftpdf.apps.googleusercontent.com'
    api: url: '//localhost:3000'
    mobile: url: '#'

  staging: $.extend true, {}, defaults,
    vendor:
      facebook: app_id: '1457484574486556'
      google: client_id: '686822539338-h8pp1erjru867em1h45f7rf0qe0ftpdf.apps.googleusercontent.com'
    api: url: 'https://api.s.gymcloud.com'
    mobile:
      app: 'gymcloud://'
      url: 'https://mobile.s.gymcloud.com'

  production: $.extend true, {}, defaults,
    vendor:
      facebook: app_id: '444988735644338'
      google: client_id: '512657583504-f9e94bg98gfg0mavfqv84nqthv9o0acg.apps.googleusercontent.com'
      hotjar:
        hjid: 154712
        hjsv: 5
      google_analytics:
        account: 'UA-74824574-3'
      stripe:
        publishable_key: 'pk_live_OaMTNwWnnagp4nLqJhwrkiUU'
      mixpanel:
        token: 'e1e68dc7cedb942ee97a42fd97c3396b'
    api: url: 'https://api.gymcloud.com'
    mobile:
      app: 'gymcloud://'
      url: 'https://mobile.gymcloud.com'
    features:
      sign_up: enabled: false
      hotjar: enabled: true
      freshdesk_widget: enabled: true
      google_analytics: enabled: true
      mixpanel: enabled: true
      refer_friend: enabled: false

  test: $.extend true, {}, defaults,
    api: url: ''
    mobile: url: '#'
