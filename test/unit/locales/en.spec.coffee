define [
  'locales/en'
], (
  locale
) ->

  context 'locales', ->

    describe 'en', ->

      before ->
        @it = locale

      it 'is present', ->
        expect(@it)
          .to.be.an('object')

      it '#explain', ->
        expect(@it)
          .to.have.property('explain')

      it 'has properties', ->

        properties = [
          'message.success'
          'message.error'
          'error.unknown'
          'error.mobile_only'
          'login.failed'
          'login.unauthorized'
          'login.abscent'
          'user.password.changed'
          'user.password.invalid_token'
          'user.invitation.sent'
          'user.account_type.changed'
          'item.added'
          'item.deleted'
          'item.not_deleted'
          'item.updated'
          'item.not_updated'
          'item.not_selected'
          'item.duplicated'
          'item.moved'
          'item.added_to_library'
          'item.client.assigned'
          'item.client.unassigned'
          'item.client_group.assigned'
          'item.client_group.unassigned'
          'folder.added'
          'workout_exercise.added'
          'exercise.updated'
          'exercise.deleted'
          'workout.deleted'
          'program.updated'
          'program.not_updated'
          'program.deleted'
          'program_workout.saved'
          'video.deleted'
          'video.updated'
          'video.invalid_type'
          'video.search.error'
          'week.added'
          'week.deleted'
          'client_groups.empty'
          'personal_best.added'
          'personal_program.empty'
          'personal_workout.empty'
        ]

        _.each properties, (property) =>

          expect(@it.explain)
            .to.have.deep.property(property)
