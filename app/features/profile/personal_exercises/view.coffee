define [
  './list/view'
  '../personal_assignments/template'
  'collections/user_collection'
  'models/exercise'
], (
  ListView
  template
  UserCollection
  Exercise
) ->

  class PersonalExercisesLayoutView extends Marionette.LayoutView

    template: template

    className: 'gc-exercises-assign'

    behaviors: ->

      stickit:
        bindings:
          'input.gc-exercises-assign-input':
            attributes: [
                name: 'placeholder'
                observe: 'name'
                onGet: (value) -> 'Search exercise'
            ]

      regioned:
        views: [
            region: 'list'
            klass: ListView
            options: ->
              user: @model
              collection: new UserCollection [],
                user: @model
                model: Exercise
                type: 'personal_exercises'
        ]

      auto_complete:

        onItemAdd: (id, $item, selectize) ->
          intId = parseInt(id, 10)

          path = ['users', @model.id, 'exercises', intId]
          App.vent.trigger 'redirect:to', path,
            replace: false

          selectize.clear()
          selectize.close()

        collection: ->
          App.request('current_user').personal_exercises

        serealizeFn: (item) ->
          folder: item.folder?.get('name')
          id: item.get('id')
          name: item.get('name')
          label: item.get('name')
          sort_id: _.underscore(item.get('name'))
