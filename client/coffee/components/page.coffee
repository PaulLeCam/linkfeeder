define [
  "ext/framework"
  "sandbox/widget"
], (framework, sandbox) ->

  class Page extends framework.mvc.View

    start: (previous) ->
      @load() if previous?

    stop: ->

    load: (url = @url) ->
      dfd = sandbox.deferred()
      if @$el? and url? then @$el.load url, dfd.resolve
      else dfd.reject()
      dfd.promise()
