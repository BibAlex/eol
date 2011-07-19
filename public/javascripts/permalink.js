$(function() {
  (function($form) {
    var actions = {
      trusted: function() {
        this.closest("fieldset").find("ul").hide()
          .end().find("select[name=visibility]").prop("disabled", false).trigger("change");
      },
      untrusted: function() {
        this.closest("fieldset").find("select[name=visibility]").val("hidden").prop("disabled", true)
          .end().find("ul").hide().filter(".untrusted").show();
      },
      inappropriate: function() {
        this.closest("fieldset").find("select[name=visibility]").val("hidden").prop("disabled", true)
          .end().find("ul").hide();
      },
      hidden: function () {
        this.closest("fieldset").find("ul").hide().filter(".hidden").show();
      },
      visible: function() {
        this.closest("fieldset").find("ul").hide();
      }
    };

    $form.find("select").change(function() {
      var $e = $(this);
      if ($e.is(":enabled")) {
        actions[$e.find(":selected").val()].apply($e);
      }
    }).trigger("change");

  })($("form.review_status"));
});