define [
  './original'
  './helpers'
  'moment-timezone'
], (
  oMoment
  Helpers
) ->

  zone = oMoment.tz.guess()
  oMoment.tz.setDefault(zone)
  oMoment.h = new Helpers(oMoment)
  oMoment
