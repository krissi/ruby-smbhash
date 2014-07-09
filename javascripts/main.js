function submit_password() {
  update_results_in_form('', '');
  password = get_password_from_form();

  console.log(password);
  if(password != null) {
    do_query(password);
  }
}

function get_password_from_form() {
  password = $('#password').val();
  if(confirm("The entered password will be sent to the server. If you use this password in any place press cancel now!") == true) {
    return password;
  }

  return null;
}

function do_query(password) {
  $.ajax({
    url: "https://smbhash-service.herokuapp.com/hash/" + password,
    jsonp: "callback",
    dataType: "jsonp",
    success: function( response ) {
      update_results_in_form(response.lm_hash, response.ntlm_hash);
    }
  });
}

function update_results_in_form(lm_hash, ntlm_hash) {
  $('#lm_hash').val(lm_hash);
  $('#ntlm_hash').val(ntlm_hash);
}

