define [
  "sandbox/widget"
  "widgets/link-add"
  "bootstrap-modal"
], (sandbox) ->

  class LinkAddModal extends sandbox.Widget

    events:
      "shown.bs.modal": "shownModal"
      "hide.bs.modal": "hideModal"

    initialize: (@options = {}) ->
      @linkAddOptions = sandbox.util.extend {}, @options
      @linkAddOptions.el = "#{ @$el.selector } form"
      @linkAddPromise = sandbox.widgets.initialize "link-add", @linkAddOptions

    start: (options) ->
      sandbox.util.extend @linkAddOptions, options
      @$el.modal "show"

    stop: ->
      @$el.modal "hide"
      super

    remove: ->
      @stop()

    shownModal: ->
      @linkAddPromise.done (w) => w.start @linkAddOptions

    hideModal: ->
      @linkAddPromise.done (w) => w.stop()
      sandbox.emit "navbar-form:enable"
