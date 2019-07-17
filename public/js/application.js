$(document).ready(function() {
  if ($('.root-page').length > 0) {
    $('#projects_dt').DataTable({
      processing: true,
      serverSide: true,
      dom: 'rtip',
      pageLength: 15,
      autoWidth: true,
      paging: true,
      ajax: {
        url: '/versions.json'
      },
      createdRow: function(row, data, dataIndex) {
        let tooltip = data[data.length - 1];
        if (tooltip != null) {
          $(row).children('td').addClass('bad_version');
          $(row).attr('data-toggle', 'tooltip');
          $(row).attr('data-html', 'true');
          $(row).attr('title', tooltip);
          $(row).tooltip();
        }
      }
    });
  }

  if ($('.requirements-page').length > 0) {
    $('.load-versions-btn').on('click', function(e) {
      let $btn = $(e.target);
      $btn.find('.spinner').removeAttr('hidden');
      $('#overlay').fadeIn(100);
    })
  }
});
