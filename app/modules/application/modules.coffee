define [
  'routers/all'
  'features/current_user/module'
  'features/header/module'
  'features/spinner/module'
  'features/messenger/module'
  'features/sidebar/module'
  'features/search/module'
  'features/modal/confirm/module'
  'features/modal/prompt/module'
  'features/modal/client_groups/module'
  'features/modal/assign_video/module'
  'features/drag_n_drop/module'
  'features/tutorial/module'
  'modules/utils/freshdesk'
  'modules/utils/google_analytics'
], (
  AllRouters
  CurrentUserModule
  HeaderModule
  SpinnerModule
  MessengerModule
  SidebarModule
  SearchModule
  ModalConfirmModule
  ModalPromptModule
  ModalClientGroupModule
  ModalAssignVideo
  DragNDropModule
  TutorialModule
  FreshDeskModule
  GoogleAnalyticsModule
) ->

  (app) ->

    app.module 'AllRouters', AllRouters
    app.module 'CurrentUser', CurrentUserModule
    app.module 'Header', HeaderModule
    app.module 'Sidebar', SidebarModule
    app.module 'Spinner', SpinnerModule
    app.module 'Messenger', MessengerModule
    app.module 'Search', SearchModule
    app.module 'ModalConfirm', ModalConfirmModule
    app.module 'ModalPrompt', ModalPromptModule
    app.module 'ClientGroupModal', ModalClientGroupModule
    app.module 'ModalAssignVideo', ModalAssignVideo
    app.module 'DragNDrop', DragNDropModule
    app.module 'TutorialModule', TutorialModule
    if feature.isEnabled('freshdesk_widget')
      app.module 'FreshDesk', FreshDeskModule
    if feature.isEnabled('google_analytics')
      app.module 'GoogleAnalytics', GoogleAnalyticsModule
