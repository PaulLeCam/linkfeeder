module.exports = (grunt) ->

  require("load-grunt-tasks") grunt
  grunt.initConfig

    dir:
      shared:
        root: "shared"
        templates: "shared/templates"
      client:
        bower_components: "client/bower_components"
        assets: "client/assets"
        code: "client/coffee"
        widgets: "client/widgets"
        styles: "client/less"
      build:
        root: "client/build"
        css: "client/build/css"
        js: "client/build/js"
        templates: "client/build/js/templates"
        widgets: "client/build/js/widgets"
      prod:
        root: "client/www"
        css: "client/www/css"
        js: "client/www/js"
        widgets: "client/www/js/widgets"

    clean:
      build: "<%= dir.build.root %>"
      prod: "<%= dir.prod.root %>"
      widgets: "<%= dir.prod.widgets %>/*/*"

    copy:
      bower_components:
        files: [
          {src: "<%= dir.client.bower_components %>/requirejs/require.js", dest: "<%= dir.build.js %>/lib/require.js"}
          {src: "<%= dir.client.bower_components %>/json3/lib/json3.js", dest: "<%= dir.build.js %>/lib/json3.js"}
          {src: "<%= dir.client.bower_components %>/lodash/dist/lodash.compat.js", dest: "<%= dir.build.js %>/lib/lodash.js"}
          {src: "<%= dir.client.bower_components %>/jquery/jquery.js", dest: "<%= dir.build.js %>/lib/jquery.js"}
          {src: "<%= dir.client.bower_components %>/backbone/backbone.js", dest: "<%= dir.build.js %>/lib/backbone.js"}
          {src: "<%= dir.client.bower_components %>/handlebars/handlebars.runtime.js", dest: "<%= dir.build.js %>/lib/handlebars.js"}
          {expand: yes, cwd: "<%= dir.client.bower_components %>/bootstrap/js", src: "*", dest: "<%= dir.build.js %>/lib/bootstrap"}
          {expand: yes, cwd: "<%= dir.client.bower_components %>/bootstrap/dist/fonts", src: "*", dest: "<%= dir.build.root %>/fonts"}
        ]
      assets_build:
        files: [
          expand: yes
          cwd: "<%= dir.client.assets %>"
          src: "**"
          dest: "<%= dir.build.root %>"
        ]
      assets_prod:
        files: [
          expand: yes
          cwd: "<%= dir.client.assets %>"
          src: "**"
          dest: "<%= dir.prod.root %>"
        ]

    coffee:
      shared:
        files: [
          expand: yes
          cwd: "<%= dir.shared.root %>"
          src: "**/*.coffee"
          dest: "<%= dir.build.js %>"
          ext: ".js"
        ]
      client:
        files: [
          expand: yes
          cwd: "<%= dir.client.code %>"
          src: "**/*.coffee"
          dest: "<%= dir.build.js %>"
          ext: ".js"
        ]
      widgets:
        files: [
          expand: yes
          cwd: "<%= dir.client.widgets %>"
          src: "**/*.coffee"
          dest: "<%= dir.build.widgets %>"
          ext: ".js"
        ]

    handlebars:
      shared:
        options:
          namespace: no
          amd: yes
        files: [
          expand: yes
          cwd: "<%= dir.shared.templates %>"
          src: "**/*.htm"
          dest: "<%= dir.build.templates %>"
          ext: ".js"
        ]
      widgets:
        options:
          namespace: no
          amd: yes
        files: [
          expand: yes
          cwd: "<%= dir.client.widgets %>"
          src: "*/templates/*.htm"
          dest: "<%= dir.build.widgets %>"
          ext: ".js"
        ]

    less:
      client:
        files: [
          expand: yes
          cwd: "<%= dir.client.styles %>"
          src: "**/*.less"
          dest: "<%= dir.build.css %>"
          ext: ".css"
        ]

    watch:
      shared_code:
        files: "<%= dir.shared.root %>/**/*.coffee"
        tasks: "coffee:shared"
      client_code:
        files: "<%= dir.client.code %>/**/*.coffee"
        tasks: "coffee:client"
      widgets_code:
        files: "<%= dir.client.widgets %>/**/*.coffee"
        tasks: "coffee:widgets"
      shared_templates:
        files: "<%= dir.shared.templates %>/**/*.htm"
        tasks: "handlebars:shared"
      widgets_templates:
        files: "<%= dir.client.widgets %>/*/templates/*.htm"
        tasks: "handlebars:widgets"
      styles:
        files: "<%= dir.client.styles %>/**/*.less"
        tasks: "less"

    cssmin:
      prod:
        files: [
          expand: yes
          cwd: "<%= dir.build.css %>"
          src: "**/*.css"
          dest: "<%= dir.prod.css %>"
        ]

    requirejs:
      compile:
        options:
          baseUrl: "<%= dir.build.js %>"
          mainConfigFile: "<%= dir.build.js %>/config.js"
          dir: "<%= dir.prod.js %>"
          modules: [
            {name: "app", include: [
              "components/page"
              "models/link"
            ]}
            {name: "pages/home", exclude: ["app"]}
            {name: "pages/links/create", exclude: ["app"]}
            {name: "pages/links/read", exclude: ["app"]}
            {name: "pages/tags/read", exclude: ["app"]}
            {name: "widgets/progress-bar", exclude: ["app"]}
            {name: "widgets/link-add", exclude: ["app"]}
          ]
          done: (done, output) ->
            duplicates = require("rjs-build-analysis").duplicates output

            if duplicates.length > 0
              grunt.log.subhead "Duplicates found in requirejs build:"
              grunt.log.warn duplicates
              done new Error "r.js built duplicate modules, please check the excludes option."

            done()

    concurrent:
      copy: ["copy:bower_components", "copy:assets_build"]
      build: ["coffee", "handlebars", "less"]
      prod: ["cssmin", "requirejs"]

  grunt.registerTask "build", ["clean:build", "concurrent:copy", "concurrent:build"]
  grunt.registerTask "dev", ["build", "watch"]
  grunt.registerTask "prod", ["build", "clean:prod", "copy:assets_prod", "concurrent:prod", "clean:widgets"]
  grunt.registerTask "default", ["prod"]
