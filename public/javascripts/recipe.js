SortableIngredients = function() {
  Sortable.create('ingredients', {tag: 'div', handle: 'small'});
}

set_flickr_photo = function(link, url, url_photopage) {
  $('recipe_flickr_photo').value = url;
  $('recipe_flickr_photo_link').value = url_photopage;
  $$('#flickr_photos a').each(function(a) {
    if (a.hasClassName("on")) {
      a.removeClassName("on")
    }
  })
  $(link).addClassName("on");
}