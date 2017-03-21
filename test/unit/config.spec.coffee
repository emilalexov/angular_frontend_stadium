define [
  'config'
], (
  config
) ->

  describe 'config', ->

    it 'is present', ->

      expect(config)
        .to.be.an('object')

    it 'has api url', ->

      expect(config)
        .to.have.property('api')
      expect(config.api)
        .to.have.property('url')

    it 'has mobile url', ->

      expect(config)
        .to.have.property('mobile')
      expect(config.api)
        .to.have.property('url')

    it 'has vendor config', ->

      expect(config)
        .to.have.property('vendor')

    it 'has facebook keys', ->

      expect(config.vendor)
        .to.have.property('facebook')
      expect(config.vendor.facebook)
        .to.have.property('app_id')

    it 'has google keys', ->

      expect(config.vendor)
        .to.have.property('google')
      expect(config.vendor.google)
        .to.have.property('client_id')

    it 'has stripe keys', ->

      expect(config.vendor)
        .to.have.property('stripe')
      expect(config.vendor.stripe)
        .to.have.property('publishable_key')

    it 'has features config', ->

      expect(config)
        .to.have.property('features')
