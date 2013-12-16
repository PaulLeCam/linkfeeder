define [
  "sandbox/service"
  "harvey"
], (sandbox, Harvey) ->

  # Large
  Harvey.attach "screen and (min-width:1200px)",
    setup: -> sandbox.emit "responsive:large:setup"
    on: ->
      sandbox.emit "responsive:large:active"
      sandbox.emit "responsive:resize", "large"
    off: -> sandbox.emit "responsive:large:inactive"

  # Default
  Harvey.attach "screen and (min-width:980px) and (max-width:1199px)",
    setup: -> sandbox.emit "responsive:default:setup"
    on: ->
      sandbox.emit "responsive:default:active"
      sandbox.emit "responsive:resize", "default"
    off: -> sandbox.emit "responsive:default:inactive"

  # Medium
  Harvey.attach "screen and (min-width:768px) and (max-width:979px)",
    setup: -> sandbox.emit "responsive:medium:first"
    on: ->
      sandbox.emit "responsive:medium:active"
      sandbox.emit "responsive:resize", "medium"
    off: -> sandbox.emit "responsive:medium:inactive"

  # Reduced
  Harvey.attach "screen and (min-width:481px) and (max-width:769px)",
    setup: -> sandbox.emit "responsive:reduced:first"
    on: ->
      sandbox.emit "responsive:reduced:active"
      sandbox.emit "responsive:resize", "reduced"
    off: -> sandbox.emit "responsive:reduced:inactive"

  # Small
  Harvey.attach "screen and (max-width:480px)",
    setup: -> sandbox.emit "responsive:small:first"
    on: ->
      sandbox.emit "responsive:small:active"
      sandbox.emit "responsive:resize", "small"
    off: -> sandbox.emit "responsive:small:inactive"
