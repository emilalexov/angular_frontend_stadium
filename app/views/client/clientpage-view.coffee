module.exports = class ClientPageView extends Marionette.LayoutView

  template: require('templates/client/clientpage')

  regions:
    nav: '#clientpage-nav-region'
    content: '#clientpage-content-region'
