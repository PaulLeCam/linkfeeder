define [
  "components/page"
], (Page) ->

  class ReadTagPage extends Page

    el: "#content"

    start: (previous, tag, page = 1) ->
      @url = "/#{ tag }/#{ page }"
      super arguments
