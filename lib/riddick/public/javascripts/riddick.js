(function($) {
  $(function() {
    // Confirmation dialog for delete-links.
    $('[data-confirm]').click(function() {
      return window.confirm($(this).data('confirm'));
    });

    // Use chosen to for translation path select field.
    $('[data-chosen]').chosen().change(function() {
      $($('[data-chosen]').data('for')).val($(this).find(':selected').data('v'));
      $($('[data-chosen]').data('for')).focus();
    });

    // Change translation path and value fields, when clicking on the edit-button.
    $('[data-choose]').click(function() {
      $('[data-chosen] option[value="' + $(this).data('choose') + '"]').attr('selected', true);
      $($('[data-chosen]').data('for')).val($(this).data('v'));
      $($('[data-chosen]').data('for')).focus();
      $('[data-chosen]').trigger('liszt:updated'); // Trigger 'Chosen'-event.
      return true;
    });

    // Initialize bootstraps' popovers.
    $('[rel=popover]').popover();
  });
})(jQuery);
