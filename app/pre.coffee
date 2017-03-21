define [
  'config'
  'modules/pre/redirect_to_mobile'
], (
  config
  RedirectToMobile
) ->

  new RedirectToMobile
    appPath: config.mobile.app
    appUrl: config.mobile.url
