define ->

  class SignUpStep2Model extends Backbone.Model

    urlRoot: '/user_profiles'

    validation:

      first_name:
        required: true

      last_name:
        required: true

      address:
        required: true

      city:
        required: true

      state:
        required: true

      zip:
        required: true
        pattern: 'digits'

      birth_day:
        required: true

      birth_month:
        required: true

      birth_year:
        required: true

      gender:
        required: true
        oneOf: ['male', 'female']

      agree:
        acceptance: true
