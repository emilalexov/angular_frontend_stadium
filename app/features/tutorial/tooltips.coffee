define ->

  [
      id: 0
      uniq_id: 'folder_list_add_exercise'
      key: 'FolderListView'
      element: (view) -> view.ui.itemAddButton
      rule: -> /\/#exercises/.test(window.location.href)
      main: true
      title: '''The first step in maximizing your GymCloud experience as a
                fitness professional is creating exercises.'''
      content: 'Click this button to start creating your first exercise.'
      docs: '3000047997--web-trainer-exercises-how-to-add-a-folder'
    ,
      id: 0
      uniq_id: 'folder_list_add_workout_template'
      key: 'FolderListView'
      element: (view) -> view.ui.itemAddButton
      rule: -> /\/#workout_templates/.test(window.location.href)
      main: true
      title: '''Adding properties to the exercises in a workout helps you
                provide complete instructions.'''
      content: 'Start creating your first workout by clicking this button.'
      docs: '3000048002--webapp-workouts-how-to-create-a-new-workout'
    ,
      id: 0
      uniq_id: 'folder_list_add_program_template'
      key: 'FolderListView'
      element: (view) -> view.ui.itemAddButton
      rule: -> /\/#program_templates/.test(window.location.href)
      main: true
      title: '''Having created exercises and workouts, you can now combine
                them and create a program.'''
      content: 'To start creating a program, click this button.'
      docs: '3000048794--webapp-programs-how-to-add-new'
    ,
      id: 1
      uniq_id: 'folder_list_edit_program_template'
      key: 'FolderListView'
      element: (view) -> view.$('.gc-folder-item .gc-exercises-link:first')
      rule: -> /\/#program_templates/.test(window.location.href)
      title: '''Add weeks to your program depending on how long you would like
                it to last.'''
      content: 'First, click your program.'
      docs: '3000048884--webapp-programs-how-to-set-weeks'
    ,
      id: 0
      uniq_id: 'client_search_to_assign'
      key: 'AssignedTemplatesLayoutView'
      element: (view) -> $('.gc-exercises-assign-input-wrapper input:last')
      rule: -> /\/#users\/\d+\/programs/.test(window.location.href)
      main: true
      title: 'Assigning Items To A Client'
      content: '''Type here the name of the workout you want to assign and
                  click it.'''
      docs: '3000050220--web-clients-how-to-assign-workouts-and-programs'
      onShow: -> $('.gc-exercises-assign-input-wrapper input').click()
    ,
      id: 0
      uniq_id: 'program_constructor_add_week'
      key: 'EditableProgramActionPanel'
      element: (view) -> view.$('.add-week')
      rule: -> /\/#program_templates\/\d+/.test(window.location.href)
      main: true
      title: '''Add weeks to your program depending on how long you would like
                it to last.'''
      content: 'And hit this button.'
      docs: '3000048219--webapp-workouts-how-to-add-descriptions-notes'
    ,
      id: 1
      uniq_id: 'program_constructor_add_workout'
      key: 'EditableProgramActionPanel'
      element: (view) -> view.$('.add-workout')
      rule: -> /\/#program_templates\/\d+/.test(window.location.href)
      title: '''Instruct your clients what to do on each program week by
                adding workout/s to it.'''
      content: 'To add a workout click this button.'
      docs: '3000048848--webapp-programs-how-to-add-workout'
    ,
      id: 0
      uniq_id: 'exercise_constructor_edit_description'
      key: 'ExerciseOverviewView'
      element: (view) -> view.$('.gc-editable-textarea textarea')
      rule: -> /\/#exercises\/\d+/.test(window.location.href)
      main: true
      title: '''Give your clients information about the exercise by
                adding descriptions to it.'''
      content: 'Start typing your exercise description here.'
      docs: '3000047605--webapp-exercises-how-to-add-descriptions'
    ,
      id: 1
      uniq_id: 'exercise_constructor_add_video'
      key: 'ExerciseOverviewView'
      element: (view) -> view.$('.gc-add-video')
      rule: -> /\/#exercises\/\d+/.test(window.location.href)
      title: '''Adding a video to your exercise helps your clients
                understand the proper execution of an exercise.'''
      content: '''Click either of these buttons to add a video to your
                  exercise.'''
      docs: '3000048220--webapp-workouts-how-to-add-a-video'
    ,
      id: 0
      uniq_id: 'workout_constructor_edit_description'
      key: 'WorkoutOverviewView'
      element: (view) -> view.$('.gc-editable-textarea textarea')
      rule: -> /\/#workout_templates\/\d+/.test(window.location.href)
      main: true
      title: '''Give your client general information about the workout by
                adding notes to it.'''
      content: 'Start typing your workout notes / descriptions here.'
      docs: '3000048219--webapp-workouts-how-to-add-descriptions-notes'
    ,
      id: 1
      uniq_id: 'workout_constructor_add_exercise'
      key: 'QuickAddView'
      element: (view) -> view.$('.quick-add')
      rule: -> /\/#workout_templates\/\d+/.test(window.location.href)
      title: 'Add Exercise.'
      content: '''Add the exercises you want to include in your workout by
                  clicking here.'''
      docs: '3000048221--webapp-workouts-how-to-add-exercises'
    ,
      id: 2
      uniq_id: 'workout_constructor_add_exercise_note'
      key: 'WorkoutExercisesListItemView'
      element: (view) -> view.ui.note
      rule: -> /\/#workout_templates\/\d+/.test(window.location.href)
      title: '''Adding notes to exercises in a workout is useful to help your
                clients execute exercises correctly.'''
      content: 'Start typing your exercise note(s) here.'
      docs: '3000048276--web-workouts-how-to-add-exercise-notes'
    ,
      id: 3
      uniq_id: 'workout_constructor_add_exercise_property'
      key: 'WorkoutExercisesListItemView'
      element: (view) -> view.ui.addSingleProperty
      rule: -> /\/#workout_templates\/\d+/.test(window.location.href)
      title: '''Provide your client instructions by adding properties to your
                exercises in a workout.'''
      content: '''To add properties, hover to your exercise and hit this
                  button.'''
      docs: '3000048272--web-workouts-how-to-add-exercise-properties'
    ,
      id: 4
      uniq_id: 'workout_constructor_add_exercise_order'
      key: 'WorkoutExercisesListItemView'
      element: (view) -> view.$('.gc-workout-exercise-circle')
      rule: -> /\/#workout_templates\/\d+/.test(window.location.href)
      title: '''Change the order of your exercises to alphanumeric. Those that
                have the same letter are in one set.'''
      content: 'Click here and change its name to A1.'
      docs: '3000048279--webapp-workouts-how-to-connect-exercises-'+
            'to-create-a-set'
    ,
      id: 0
      uniq_id: 'clients_add_client'
      key: 'ClientsView'
      element: (view) -> view.$('.show-client-form:first')
      rule: -> /\/#clients/.test(window.location.href)
      main: true
      title: '''Once you established a library of your exercises, workouts and
                programs, you can now add your clients.'''
      content: 'Hit this button to start adding a client.'
      docs: '3000048490--web-clients-how-to-add-new'
      onNext: -> @view.showClientAddModal()
    ,
      id: 1
      uniq_id: 'clients_add_client_form'
      key: 'ClientsView'
      element: (view) -> '.gc-client-modal input:first'
      rule: -> /\/#clients/.test(window.location.href)
      title: '''Allow your client to manage his/her own workouts and programs
                by inviting him/her to GymCloud.'''
      content: 'First, click your client\'s name.'
      docs: '3000048491--web-clients-how-to-register'
      orphan: true
      onPrev: -> @view.ui.modalContainer.modal('hide')
    ,
      id: 2
      uniq_id: 'clients_add_client_form_submit'
      key: 'ClientsView'
      element: (view) -> '.gc-client-modal button[type="submit"]:first'
      rule: -> /\/#clients/.test(window.location.href)
      title: 'Inviting A Client To GymCloud'
      content: 'Then, hit this button and enter your client\'s email address.'
      docs: '3000048491--web-clients-how-to-register'
      onNext: -> @view.ui.modalContainer.modal('hide')
    ,
      id: 3
      uniq_id: 'clients_add_group'
      key: 'ClientsView'
      element: (view) -> view.$('.show-group-form:first')
      rule: -> /\/#clients/.test(window.location.href)
      title: 'Creating A Client Group.'
      content: '''Creating a group of clients will make it easier for you to
                  batch assign workouts and programs.'''
      docs: '3000048495--web-clients-how-to-create-a-group'
      onPrev: -> @view.showClientAddModal()
      onNext: -> @view.showGroupAddModal()
    ,
      id: 4
      uniq_id: 'clients_add_group2'
      key: 'ClientsView'
      element: (view) -> '.modal button[type="submit"]:first'
      rule: -> /\/#clients/.test(window.location.href)
      title: 'Creating A Client Group.'
      content: 'To create a client group, click here.'
      docs: '3000048495--web-clients-how-to-create-a-group'
      orphan: true
      onPrev: -> @view.ui.modalContainer.modal('hide')
      onNext: -> @view.ui.modalContainer.modal('hide')
    ,
      id: 5
      uniq_id: 'clients_point_client'
      key: 'ClientsView'
      element: (view) -> '.gc-clients-list-client-link:first'
      rule: -> /\/#clients/.test(window.location.href)
      title: 'Moving A Client To A Client Group.'
      content: 'Organize your clients by moving them to a client group.'
      docs: '3000048496--webapp-clients-how-to-add-to-group-through-clients-'+
            'list-page'
      onPrev: -> @view.showGroupAddModal()
      onNext: ->
        $('.gc-clients-list-client-actions:first').addClass('active')
    ,
      id: 6
      uniq_id: 'clients_move_client_to_group'
      key: 'ClientsView'
      element: (view) -> '.gc-clients-list-client-move:first'
      rule: -> /\/#clients/.test(window.location.href)
      title: 'Moving A Client To A Client Group.'
      content: 'To do this, simply click this button.'
      docs: '3000048496--webapp-clients-how-to-add-to-group-through-clients-'+
            'list-page'
      onPrev: ->
        $('.gc-clients-list-client-actions:first').removeClass('active')
      onNext: ->
        $('.gc-clients-list-client-actions:first').removeClass('active')
    ,
      id: 0
      uniq_id: 'clients_sidebar_programs1'
      key: 'SidebarPersonalRootFolderView'
      element: (view) -> view.el
      rule: (view) -> view.type is 'personal_programs'
      main: true
      title: 'Program Overview'
      content: '''With a GymCloud account, you can easily view all the
                  exercises, workouts and programs assigned to you.'''
      docs: '3000049945--web-client-program-overview'
    ,
      id: 1
      uniq_id: 'clients_sidebar_programs2'
      key: 'SidebarPersonalRootFolderView'
      element: (view) -> view.el
      rule: (view) -> view.type is 'personal_programs'
      title: 'Program Overview'
      content: '''To see the programs assigned to you by your trainer, this is
                  the button you will click.'''
      docs: '3000049945--web-client-program-overview'
    ,
      id: 2
      uniq_id: 'clients_sidebar_workouts'
      key: 'SidebarPersonalRootFolderView'
      element: (view) -> view.el
      rule: (view) -> view.type is 'personal_workouts'
      title: 'Workout Overview'
      content: '''To view the workouts assigned to you by your trainer, this is
                  the button you will use.'''
      docs: '3000049944--web-client-workout-overview'
    ,
      id: 3
      uniq_id: 'clients_sidebar_exercises'
      key: 'SidebarPersonalRootFolderView'
      element: (view) -> view.el
      rule: (view) -> view.type is 'workout_exercises'
      title: 'Exercise Overview'
      content: '''You will also have an exercise library, which includes
                  exercises from your workouts and programs.'''
      docs: '3000053218--web-client-exercise-overview'
    ,
      id: 4
      uniq_id: 'clients_sidebar_exercises'
      key: 'SidebarPersonalRootFolderView'
      element: (view) -> view.el
      rule: (view) -> view.type is 'workout_exercises'
      title: 'Exercise Overview'
      content: '''To check your list of exercises, the is the button you will
                  click.'''
      docs: '3000053218--web-client-exercise-overview'
  ]