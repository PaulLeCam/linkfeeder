define [
  "sandbox/widget"
  "models/link"
  "services/page-infos"
  "bootstrap-button"
], (sandbox, Link, getPageInfos) ->

  class LinkAdd extends sandbox.Widget

    events:
      "submit": "handleForm"
      "reset": "handleReset"

    initialize: (@options = {}) ->
      @$uri = @$ "#link-uri"
      @$title = @$ "#link-title"
      @$desc = @$ "#link-description"
      @$image = @$ ".link-image"
      @$btnSubmit = @$ "button[type=submit]"
      @$btnReset = @$ "button[type=reset]"
      @$formContainer = @$ ".link-extra"

      @progressPromise = sandbox.widgets.initialize "progress-bar",
        el: "#link-progress"
        duration: 3000

      if @options.uri? and @options.uri.length
        @$uri.val @options.uri
        @loadInfos @options.uri

    remove: ->
      sandbox.widgets.remove "#link-progress"
      super()

    handleReset: ->
      @$uri.prop "disabled", no
      @$btnSubmit.button "reset"
      @$formContainer.addClass "hide"
      @$btnReset.addClass "hide"
      delete @model

    handleForm: ->
      uri = @$uri.val()
      return no unless uri? and uri.length

      if @model
        @$btnSubmit.button "loading"
        @model.save(
          title: @$title.val()
          description: @$desc.val()
        )
          .always(=>
            @$btnSubmit.button "reset"
          )
          .fail((err) ->
            sandbox.dev.error err
            # display error message on UI
          )
          .done =>
            sandbox.emit "link:create", @model
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

      getPageInfos(uri)
        .always(=>
          @$btnSubmit.button "reset"
          @progressPromise.done (w) -> w.stop()
        )
        .fail(->
          sandbox.dev.error "Could not load info"
          # display error message on UI
        )
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
