define [
  './template'
  './item/view'
], (
  template
  ItemView
) ->

  class DayView extends Marionette.CompositeView

    template: template

    className: 'table-container'

    childView: ItemView

    childViewContainer: 'tbody'

    behaviors: ->
      stickit:
        bindings:
          ':el':
            classes:
              'with-bg':
                observe: 'date'
                onGet: (date) -> moment(date) < moment().startOf('day')

          'caption.table-title':
            observe: 'date'
            onGet: (value) ->
              moment(value).format('dddd, Do [of] MMMM')
