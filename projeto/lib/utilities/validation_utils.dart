bool validateEmail(String email) {
  // Check if email starts with 'UP' or 'up' (case insensitive)
  bool startsWithUP = email.startsWith(RegExp(r'^[Uu][Pp]'));

  // Check if email contains at least one number after 'UP' or 'up' followed by @up.pt
  bool containsNumber = RegExp(r'^(?:[Uu][Pp])\d+@up\.pt$').hasMatch(email);


  // Check if email ends with '@up.pt'
  bool endsWithUpPt = email.toLowerCase().endsWith('@up.pt');

  // Return true only if all conditions are met
  return startsWithUP && containsNumber && endsWithUpPt;
}


bool validatePassword(String password) {
  // Check if the password is at least 8 characters long
  if (password.length < 8) {
    return false;
  }

  // Check if the password contains at least one lowercase letter
  if (!RegExp(r'[a-z]').hasMatch(password)) {
    return false;
  }

  // Check if the password contains at least one uppercase letter
  if (!RegExp(r'[A-Z]').hasMatch(password)) {
    return false;
  }

  // Check if the password contains at least one number
  if (!RegExp(r'\d').hasMatch(password)) {
    return false;
  }

  // Password meets all criteria
  return true;
}

