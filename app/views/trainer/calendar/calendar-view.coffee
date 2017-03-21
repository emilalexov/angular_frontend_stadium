CalendarDayView = require 'views/trainer/calendar/calendar-day-view'
CalendarWeekView = require 'views/trainer/calendar/calendar-week-view'
CalendarMonthView = require 'views/trainer/calendar/calendar-month-view'

class CalendarEvents extends Backbone.Collection

  url: '/api/mobile/calendar/'

module.exports = class CalendarView extends Marionette.LayoutView

  template: require('templates/trainer/calendar/calendar')

  events:
    'click @ui.calendarNav': 'navLinkClick'

  ui:
    calendarNav: '.calendar-nav'

  regions:
    calendar: '#calendar-content'

  behaviors:
    navigate_back: true

  navLinkClick: (ev) ->
    @ui.calendarNav.removeClass('active')
    @$el.find(ev.currentTarget).addClass('active')
    navView = @$el.find(ev.currentTarget).data('nav-view')
    @loadCalendarView navView

  initialize: ->
    @currentDate = moment()
    @calendarEventCollection = new CalendarEvents
    @calendar_url = @calendarEventCollection.url

    year = @currentDate.year()
    month = @currentDate.month() + 1
    @getData year, month

  getData: (year, month) ->
    @calendarEventCollection.url =
      "#{@calendar_url}?year=#{year}&month=#{month}"
    @calendarEventCollection.fetch()

  onShow: =>
    @loadCalendarView 'day'

  loadCalendarView: (navView) =>
    switch navView
      when 'day'
        @calendarView = new CalendarDayView
      when 'week'
        @calendarView = new CalendarWeekView
      when 'month'
        @calendarView = new CalendarMonthView
    @calendar.show @calendarView
