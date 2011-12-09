EOL.init_comment_behaviours = function($items) {
  $items.each(function() {
    var $li = $(this);

    // TODO try changing the input to :submit, which is a jQuery shortcut
    $li.find(".edit_comment_form input[type='submit']").click(function() {
      var $node = $(this).closest("li");
      EOL.ajax_submit($(this), {
        update: $node,
        data: $(this).closest(".edit_comment_form").find("input, textarea").serialize(),
        complete: function() {
          $node.find(".edit_comment_form").hide().prev().show().prev().show().prev().show().prev().show();
          EOL.init_comment_behaviours($node);
        }
      });
      return(false);
    });

  
    $li.find('.edit_comment_form a').click(function() {
      $(this).closest('.edit_comment_form').hide().prev().show().prev().show().prev().show().prev().show();
      return(false);
    });
  
    $li.find('p.edit a').click(function() {
      var comment = $(this).attr('data-to-edit');
      $(this).parent().prev().hide().prev().hide();
      $(this).parent().hide().next().hide().next().show().find('textarea').val(comment);
      return(false);
    });

    $('p.delete a').click(function() {
      var $node = $(this).closest("li");
      $node.find('.reply').hide();
      $node.find('.edit').hide();
      $node.find('.delete').hide();
      $node.find('.details').hide();
      alert("test");
      return(false);
    });
  });
}

$(function() {
  EOL.init_comment_behaviours($('ul.feed li'));
});