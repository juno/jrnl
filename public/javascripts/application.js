$(document).ready(function() {
  $('#search-enabler').click(function () {
    $('#cse').slideToggle('fast');
    $('.gsc-input').focus();
  });
  $('#content article.post .content a').embedly({'maxWidth': 500, 'method':'replace', 'wrapElement':'div', 'className':'embedded'});
});
