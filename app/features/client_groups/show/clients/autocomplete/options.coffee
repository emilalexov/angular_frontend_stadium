define [
  './template'
], (
  template
) ->

  labelField: 'first_name'

  searchField: ['first_name', 'last_name']

  onItemAdd: (id, $item, selectize) ->
    intId = parseInt(id, 10)
    @addMember(id: intId)

    selectize.blur()
    selectize.clear()
    selectize.close()

  collection: -> @autocompleteCollection

  serealizeFn: (model) ->
    id: model.get('id')
    last_name: model.get('user_profile.last_name')
    first_name: model.get('user_profile.first_name')
    full_name: model.get('full_name')
    color: model.get('user_profile.avatar_background_color')
    url: model.get('user_profile.avatar.thumb.url')
    sort_id: "~-#{_.underscore(model.get('full_name'))}"

  render:
    item: template
    option: template
