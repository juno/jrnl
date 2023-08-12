jQuery(document).ready(function() {
  jQuery('#content article.post .content a:not(.noembed)').embedly({
    'maxWidth': 500,
    'method':'replace',
    'wrapElement':'div',
    'className':'embedded'
  });
});
