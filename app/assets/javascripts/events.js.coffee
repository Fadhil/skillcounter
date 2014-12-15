# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/


$(document).ready ->
  substringMatcher = (strs) ->
    findMatches = (q, cb) ->
      matches = undefined
      substringRegex = undefined
      matches = []
      substrRegex = new RegExp(q, "i")
      $.each strs, (i, str) ->
        matches.push value: str  if substrRegex.test(str)
        return

      cb matches
      return

  eventnames = gon.eventnames
  $('.typeahead').typeahead
    hint: false
    highlight: true
    minLength: 0
  ,
    name: "eventnames"
    displayKey: "value"
    source: substringMatcher(eventnames)

  return
