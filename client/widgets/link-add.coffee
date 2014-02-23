define [
  "sandbox/widget"
  "models/link"
  "services/page-infos"
  "widgets/progress-bar"
  "bootstrap-button"
], (sandbox, Link, getPageInfos) ->

  class LinkAdd extends sandbox.Widget

    events:
      "submit": "doSubmit"
      "reset": "doReset"

    initialize: (@options = {}) ->
      @$uri = @$ ".link-add-uri"
      @$title = @$ ".link-add-title"
      @$desc = @$ ".link-add-description"
      @$image = @$ ".link-add-image"
      @$btnSubmit = @$ "button[type=submit]"
      @$btnReset = @$ "button[type=reset]"
      @$formContainer = @$ ".link-add-extra"

      @progressEl = "#{ @$el.selector } .link-add-progress"
      @progressPromise = sandbox.widgets.initialize "progress-bar",
        el: @progressEl
        duration: 3000

      if @options.uri? and @options.uri.length
        @$uri.val @options.uri
        @loadInfos @options.uri

    start: (options = {}) ->
      if options.uri? and options.uri.length
        @$uri.val options.uri
        @loadInfos options.uri
      super

    stop: ->
      super
      @doReset()

    remove: ->
      sandbox.widgets.remove @progressEl
      super

    doReset: ->
      @$uri
        .prop "disabled", no
        .val ""
      @$btnSubmit.button "reset"
      @$formContainer.addClass "hide"
      @$btnReset.addClass "hide"
      delete @model

    doSubmit: (e) ->
      e.preventDefault()
      uri = @$uri.val()
      return no unless uri?.length

      if @model
        @$btnSubmit.button "loading"
        @model.save
          title: @$title.val()
          description: @$desc.val()
        .always =>
          @$btnSubmit.button "reset"
        .fail (err) ->
          sandbox.dev.error err
          # display error message on UI
        .done =>
          sandbox.emit "link:created", @model
          # Reset state
          delete @model
          @$el[0].reset()

      else
        @loadInfos uri

      no

    loadInfos: (uri) ->
      @$uri.prop "disabled", yes
      @$btnSubmit.button "loading"
      @progressPromise.done (w) -> w.start()

      getPageInfos uri
        .always =>
          @$btnSubmit.button "reset"
          @progressPromise.done (w) -> w.stop()
        .fail ->
          sandbox.dev.error "Could not load info"
          # display error message on UI
        .done (infos) =>
          @$btnSubmit.text "Create link"
          @model = new Link sandbox.util.extend {uri}, infos.meta
          @$formContainer.removeClass "hide"
          @$btnReset.removeClass "hide"

          @$title.val @model.get "title"
          @$desc.val @model.get "description"

          # add image carousel
          # if data.images.length
          #   $image.append "<img src='#{ data.images[0].src }'/>"

      no
