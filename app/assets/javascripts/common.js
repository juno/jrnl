jQuery(document).ready(function() {
  jQuery('#search-enabler').click(function() {
    jQuery('#cse').slideToggle('fast');
    jQuery('.gsc-input').focus();
  });

  jQuery('#content article.post .content a:not(.noembed)').embedly({
    'maxWidth': 500,
    'method':'replace',
    'wrapElement':'div',
    'className':'embedded'
  });
});
