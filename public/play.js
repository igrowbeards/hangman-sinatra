$( document ).ready(function() {
  function preloadImg(src) {
      $('<img/>')[0].src = src;
  }

  preloadImg('/miss-0.png');
  preloadImg('/miss-1.png');
  preloadImg('/miss-2.png');
  preloadImg('/miss-3.png');
  preloadImg('/miss-4.png');
  preloadImg('/miss-5.png');
  
  $('body').addClass('js-enabled');

  // submit form via ajax
  $('.letter.fresh').click( function(e) {
    e.preventDefault();
    $.ajax({
      method: 'post',
      url: "/guess",
      data: "guess="+$(this).find('input').val(),
      dataType: "html",
      success: function(data) {
        $('body').html(data);
      }
    });
    return false;
  });
});
