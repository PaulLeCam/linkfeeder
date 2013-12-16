require.config

  baseUrl: "/js"
  deps: ["json3", "bootstrap-collapse"]

  shim:
    # Libs
    backbone:
      deps: ["underscore", "jquery"]
      exports: "Backbone"
    handlebars:
      exports: "Handlebars"
    harvey:
      exports: "Harvey"
    # Bootstrap
    "bootstrap-affix":
      deps: ["jquery"]
    "bootstrap-alert":
      deps: ["jquery", "bootstrap-transition"]
    "bootstrap-button":
      deps: ["jquery"]
    "bootstrap-carousel":
      deps: ["jquery", "bootstrap-transition"]
    "bootstrap-collapse":
      deps: ["jquery", "bootstrap-transition"]
    "bootstrap-dropdown":
      deps: ["jquery"]
    "bootstrap-modal":
      deps: ["jquery", "bootstrap-transition"]
    "bootstrap-popover":
      deps: ["jquery", "bootstrap-tooltip"]
    "bootstrap-scrollspy":
      deps: ["jquery"]
    "bootstrap-tab":
      deps: ["jquery", "bootstrap-transition"]
    "bootstrap-tooltip":
      deps: ["jquery", "bootstrap-transition"]
    "bootstrap-transition":
      deps: ["jquery"]

  paths:
    # Utilities
    json3: "bower_components/json3/lib/json3"
    jquery: "bower_components/jquery/jquery"
    underscore: "bower_components/lodash/dist/lodash.compat"
    backbone: "bower_components/backbone/backbone"
    handlebars: "bower_components/handlebars/handlebars.runtime"
    harvey: "lib/harvey"

    # Bootstrap
    "bootstrap-affix": "bower_components/bootstrap/js/affix"
    "bootstrap-alert": "bower_components/bootstrap/js/alert"
    "bootstrap-button": "bower_components/bootstrap/js/button"
    "bootstrap-carousel": "bower_components/bootstrap/js/carousel"
    "bootstrap-collapse": "bower_components/bootstrap/js/collapse"
    "bootstrap-dropdown": "bower_components/bootstrap/js/dropdown"
    "bootstrap-modal": "bower_components/bootstrap/js/modal"
    "bootstrap-popover": "bower_components/bootstrap/js/popover"
    "bootstrap-scrollspy": "bower_components/bootstrap/js/scrollspy"
    "bootstrap-tab": "bower_components/bootstrap/js/tab"
    "bootstrap-tooltip": "bower_components/bootstrap/js/tooltip"
    "bootstrap-transition": "bower_components/bootstrap/js/transition"
