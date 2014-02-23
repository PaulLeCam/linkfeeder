define [
  "sandbox/widget"
  "./progress-bar/templates/progress"
], (sandbox, tmpl) ->

  class ProgressBar extends sandbox.Widget

    template: tmpl

    initialize: (@options = {}) ->
      super

    start: ->
      @render()
      @$progress.removeClass "hide"

      current = 0
      duration = @options.duration ? 2000 # 2secs
      progressSize = @$progress.width()
      increment = Math.ceil progressSize * 20 / duration

      @interval = setInterval =>
        @$bar.css "width", "#{ current }px"
        current += increment
        if current >= progressSize
          @$progress.addClass "active"
          @$bar.css "width", "100%"
          clearInterval @interval
      , 20

    stop: ->
      clearInterval @interval
      if @rendered
        @$progress
          .removeClass "active"
          .addClass "hide"
        @$bar.css "width", 0

    render: ->
      return if @rendered

      @$el.html @template()
      @$progress = @$ ".progress"
      @$progress.addClass @options.style if @options.style
      @$bar = @$progress.find ".progress-bar"

      @rendered = yes
      @
