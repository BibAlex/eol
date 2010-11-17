if(!EOL) { var EOL = {}; }
if (!EOL.CommonNameCuration) { EOL.CommonNameCuration = {}; }

if (!EOL.init_common_name_behaviors) {
  EOL.init_common_name_behaviors = function() {
    // Just clicking on a preferred name submits the form (and reloads the page):
    $('td.preferred_name_selector input[type="radio"]').unbind('click');
    $('td.preferred_name_selector input[type="radio"]').click(function() {
      var form = $(this).closest('form');
      form.submit();
    });
    // Colored cells need to explain themselves...
    $('td[title]').unbind('tooltip');
    $('td[title]').tooltip({delay:1});
    // Checkbox may ask the user to confirm; if they don't, it re-checks the box:
    $('td.vet_common_name select').unbind('change');
    $('td.vet_common_name select').change(function() {  // TODO - this isn't working?  Is change the wrong method?
      url = $(this).val();
      row = $(this).closest('tr');
      cell = $(this).closest('td');
      vetted_id = parseInt(url.match(/vetted_id=(\d+)/)[1]); // This WILL throw an error if it can't match.
      $.ajax({
        url: url,
        beforeSend: function() { row.fadeTo(300, 0.3); },
        // TODO - we don't really need to use the response here... not sure what I thought would change, but it won't.
        // remove.
        success: function(response) {
          cell.html(response);
          row.children().removeClass('untrusted unknown unreviewed trusted');
          if (vetted_id == EOL.Curation.UNTRUSTED_ID) {
            row.children().addClass('untrusted');
          } else if (vetted_id == EOL.Curation.UNKNOWN_ID) {
            row.children().addClass('unreviewed');
          } else {
            row.children().addClass('trusted');
          }
          EOL.init_common_name_behaviors();
        },
        error: function() { cell.html('<p>Sorry, there was an error.</p>'); },
        complete: function() { row.delay(25).fadeTo(100, 1, function() {row.css({filter:''});}); }
      });
    });
    // Confirm adding a common name:
    $("#add_common_name_button").unbind('click');
    $("#add_common_name_button").click(function() {
      var name = $.trim($("#name_name_string").val());
      var language = $("#name_language").val();
      if (name != '') {
        // TODO - i18n (put this in the view and show/hide it, duh)
        i_agree = confirm("Create a new common name?\n\nYou can always delete it later");
        if (i_agree) {
          $(this).closest('form').submit();
        }
      } else alert("Add a new common name first");
    });
  };
}

$(document).ready(function() {
  EOL.init_common_name_behaviors();
});
