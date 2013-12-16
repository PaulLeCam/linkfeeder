define [
  "components/page"
], (Page) ->

  class ReadLinkPage extends Page

    el: "#content"

    start: (previous, id) ->
      @url = "/links/#{ id }"
      super arguments
