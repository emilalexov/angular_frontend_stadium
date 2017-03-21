define ->

  sign_up: {}

  sign_in: {}

  sign_out: {}

  client_added:
    model: [
      'id'
      'email'
      'first_name'
      'last_name'
    ]

  client_invited:
    model: [
      'id'
      'email'
      'first_name'
      'last_name'
    ]

  client_group_created:
    model: ['id']

  client_group_member_added:
    model: ['id']

  client_group_member_removed:
    model: ['id']

  exercise_created:
    model: ['id']

  workout_template_created:
    model: ['id']

  program_template_created:
    model: ['id']

  video_uploaded:
    model: ['id']

  workout_assigned:
    model: ['id']

  program_assigned:
    model: ['id']

  workout_unassigned:
    model: ['id']

  program_unassigned:
    model: ['id']

  workout_scheduled:
    model: ['id']

  results_entered:
    model: ['id']

  workout_finished:
    model: ['id']

  video_watched:
    model: ['id']

  comment_posted:
    model: [
      'id'
      'commentable_type'
      'commentable_id'
    ]
