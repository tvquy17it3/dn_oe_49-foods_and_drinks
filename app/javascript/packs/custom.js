$('.new_product').on('click', '.remove-fields', function(event) {
   $(this).prev('input[type=hidden]').val('1');
   $(this).closest('fieldset').hide();
   return event.preventDefault();
});
$('.new_product').on('click', '.add_fields', function(event) {
   var regexp, time, count=0;
   fieldsets = $('fieldset').each(function(){
     if($(this).css('display') != "none"){
       count++
     }
   })
   if(count == 0){
     time = new Date().getTime();
     regexp = new RegExp($(this).data('id'), 'g');
     $(this).before($(this).data('fields').replace(regexp, time));
   }
   return event.preventDefault();
});
$('.btn-show-hide').on('click', function(event){
  if ($('.form-new').css("display") == "none")
    $('.form-new').css("display", "block")
  else
    $('.form-new').css("display", "none")
});
$('.edit_product').on('click', '.remove-fields', function(event) {
   $(this).prev('input[type=hidden]').val('1');
   $(this).closest('fieldset').hide();
   return event.preventDefault();
});
$('.edit_product').on('click', '.add_fields', function(event) {
   var regexp, time, count=0;
   fieldsets = $('fieldset').each(function(){
     if($(this).css('display') != "none"){
       count++
     }
   })
   if(count == 0){
     time = new Date().getTime();
     regexp = new RegExp($(this).data('id'), 'g');
     $(this).before($(this).data('fields').replace(regexp, time));
   }
   return event.preventDefault();
});
