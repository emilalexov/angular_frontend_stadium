define [
  './template'
  './list/view'
  './collection'
], (
  template
  PersonalBestCollectionView
  PersonalBestCollection
) ->

  class PersonalBest extends Marionette.LayoutView

    template: template

    className: 'personal-best'

    behaviors: ->

      regioned:
        views: [
            region: 'personal_best_list'
            klass: PersonalBestCollectionView
            options: ->
              collection: @collection
              user: @options.user
        ]

    initialize: ->
      @collection = new PersonalBestCollection [],
        userId: @options.user.id
        exerciseId: @options.exercise.id
      @collection.fetch()
