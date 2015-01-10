$("input[id=csv-upload]").change ->
  $("#file-name-display").val($(this).val());