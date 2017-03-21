define [
  'app/models/auth/login-model'
], (
  LoginModel
) ->

  describe 'LoginModel', ->

    describe 'instance', ->

      before ->
        @subject = new LoginModel

      it '#superclass', ->
        expect(@subject).to.be.an.instanceOf(Backbone.Model)

      it '#url', ->
        expect(@subject).to.have.property('url', '/oauth/token')

      it '#defaults', ->
        expect(@subject.attributes).to.have.property('grant_type', 'password')

      it '#validation', ->
        expect(@subject.validation).to.be.an('object')

      it '#login', ->
        expect(@subject.login).to.be.a('function')
