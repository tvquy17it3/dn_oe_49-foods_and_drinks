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
$('.button-new-address').on('click', function(event){
  if ($('#form-new-info').css("display") == "none")
    $('#form-new-info').css("display", "block")
  else
    $('#form-new-info').css("display", "none")
});
$('#info-submit').on('click', function(event){
  var name,phone,address,name_new,phone_new,address_new;

  name = $('#info-name').val();
  phone = $('#info-phone').val();
  address = $('#info-address').val();
  if(name==''||phone==''||address=='')
  {
    alert("Please Fill All Fields");
  }
  else
  {
    $('#info-lable-new').append('<label for="checked-new" class="form-lable" id="info-name-new">'+name+'</label><br>');
    $('#info-lable-new').append('<label for="checked-new" class="form-lable" id="info-phone-new">'+phone+'</label><br>');
    $('#info-lable-new').append('<label for="checked-new" class="form-lable" id="info-address-new">'+address+'</label><br>');
    $('#checked').prop('checked',false);
    $('#checked-new').prop('checked',true).val(name+"_"+phone+"_"+address)
    $('#info-new').css("display", "block")
    $('.button-new-address').css("display", "none")
    if ($('#form-new-info').css("display") == "none")
      $('#form-new-info').css("display", "block")
    else
      $('#form-new-info').css("display", "none")
  }
});
