new_email = function(){
  
  out_app = RDCOMClient::COMCreate("Outlook.Application")
  return(out_app$CreateItem(0))
  
}


add_recipients = function(...){
  
  c(...) %>% paste(collapse = ';')
  
}


address_is_valid = function(r){
  
  r %>% stringr::str_detect('^[[:alnum:]._-]+@[[:alnum:].-]+$')
  
}


check_recipients = function(recipients){
  
  check = TRUE
  for (r in recipients){
    if (!address_is_valid(r)){
      check = FALSE
      break
    }
  }
  
  return(check)
  
}


check_cc = function(cc){ 
  # wrapper for check recipients but accepts empty string
  
  if (cc == '') return(TRUE) else return(check_recipients(cc))
  
}


check_subject = function(subject){
  
  return(is.character(subject) & length(subject) == 1)
  
}


check_body = function(body){
  
  return(is.character(subject) & length(subject) == 1)
  
}


check_email_vars = function(to, subject, body, cc, bcc){
  
  return(check_recipients(to) & check_subject(subject) & check_body(body) & check_cc(cc) & check_cc(bcc))
  
}


compose_email = function(to, subject, body, cc = '', bcc = '', attachments = NULL){
  
  check = check_email_vars(to, subject, body, cc, bcc)
  
  if (check){
    
    email = new_email()
    email[['to']] = add_recipients(to)
    email[['cc']] = add_recipients(cc)
    email[['bcc']] = add_recipients(bcc)
    email[['subject']] = subject
    email[['htmlbody']] = body
    
  }
  
  for (a in attachments){
    email[['Attachments']]$Add(a)
  }
  
  return(email)
  
}


get_email_signature = function(){
  
  emp_name %global% 'First Last'
  emp_title %global% 'Special Senior Key Account Eexecutive Vice President, Ph.D'
  
  company %global% 'Company Name'
  phone %global% '+358XXXXXXXXX'
  address %global% 'Address 1 A 2'
  postal %global% 'XXXXX City'
  
  signature = cglue(
    "
    <p class=MsoNormal><b><span style='font-family:\"72 Light\",sans-serif;color:black'>
    {emp_name}
    <br>
    {emp_title}
    </span></b></p>
    
    <p class=MsoNormal><span style='font-family:\"72 Light\",sans-serif;color:black'>
    {company}
    <br>
    {phone}
    <br>
    {address}
    <br>
    {postal}
    </span></p>
    "
  )
  
  return(signature)
  
}
