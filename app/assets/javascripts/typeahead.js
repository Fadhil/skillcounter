$(document).ready(function() {
  var substringMatcher = function(strs) {
    return function findMatches(q, cb) {
      var matches, substringRegex;
      matches = [];
      substrRegex = new RegExp(q, 'i');
      $.each(strs, function(i, str) {
        if (substrRegex.test(str)) {
          matches.push({ value: str });
        }
      });
      cb(matches);
    };
  };
  var gravatars = gon.gravatars;
  varevent_names = gonevent_names;
  $('.typeahead').typeahead({
    hint: true,
    highlight: true,
    minLength: 1,
  },

  {
    name: 'event_name',
    displayKey: 'value',
    source: substringMatcher(event_name),
    templates: {
      empty: [
        '<div class="empty-message">',
        'No event_name matches found.',
        '</div>'
      ].join('\n'),
      suggestion: functionevent_name){
        return  '<div id="user-selection">' +
                '<p><strong>' +event_name.value + '</strong></p>' +
                '<img src="' + gravatars event_names.indexOfevent_name.value)] + '"/>' +
                '</div>' ;
      }
    }
  });
});