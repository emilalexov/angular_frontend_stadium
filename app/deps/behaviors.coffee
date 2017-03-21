define [
  'behaviors/exercises_connectors'
  'behaviors/facebook_login'
  'behaviors/form_validation'
  'behaviors/google_login'
  'behaviors/navigate_back'
  'behaviors/redirect_back_on_destroy'
  'behaviors/regioned'
  'behaviors/stickit'
  'behaviors/mobile_only_features'
  'behaviors/video_features'
  'behaviors/textarea_autosize'
  'features/actions_dropdown/behavior'
  'features/add_to_library/button/behavior'
  'features/author/widget/behavior'
  'features/auto_complete/behavior'
  'features/breadcrumbs/behavior'
  'features/delete_button/behavior'
  'features/editable_textarea/behavior'
  'features/navigation/content_tabs/behavior'
  'features/pagination/behavior'
  'features/privacy/toggle/behavior'
  'features/privacy/toggle2/behavior'
  'features/privacy/button/behavior'
  'features/privacy/widget/behavior'
  'features/rating/widget/behavior'
  'features/video/assigned/behavior'
  'features/program_action_panel/behavior'
  'features/program_action_panel/behavior_bottom'
  'features/exercise_properties/list/item/editable/behavior'
  'features/event_results/behavior'
  'features/print_button/behavior'
], ->

  klasses = _.toArray(arguments)

  _.reduce klasses, (memo, klass) ->
    key = _.result(klass::, 'key')
    memo[key] = klass
    memo
  , {}
