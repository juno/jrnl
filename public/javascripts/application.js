$(document).ready(function() {
  $('#search-enabler').click(function () {
    $('#cse').slideToggle('fast');
    $('.gsc-input').focus();
  });

  $('#content article.post .content a:not(.noembed)').embedly({'maxWidth': 500, 'method':'replace', 'wrapElement':'div', 'className':'embedded'});

  mpmetrics.track('page-view', {'location' : location.href});
});
