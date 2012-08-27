(function($) {
  $(function() {
    $('[data-confirm]').click(function() {
      return window.confirm($(this).data('confirm'));
    });

    $('[data-chosen]').chosen().change(function() {
      $($('[data-chosen]').data('for')).val($(this).find(':selected').data('v'));
      $($('[data-chosen]').data('for')).focus();
    });

    $('[data-choose]').click(function() {
      $('[data-chosen] option[value="' + $(this).data('choose') + '"]').attr('selected', true);
      $($('[data-chosen]').data('for')).val($(this).data('v'));
      $($('[data-chosen]').data('for')).focus();
      $('[data-chosen]').trigger('liszt:updated');
      return true;
    });

    $('[rel=popover]').popover();
  });
})(jQuery);
