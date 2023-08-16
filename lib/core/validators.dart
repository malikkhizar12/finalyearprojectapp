import 'package:get/get.dart';

String? nameValidator(String? value) {
  if (value!.isEmpty) {
    return "Please enter your name";
  }
  final regex = RegExp(r'^[a-zA-Z]+$');
  if (!regex.hasMatch(value)) {
    return "Only alphabets are allowed";
  }
  else if (value.length < 4) {
    return "Name is too short";
  }
  return null;
}

String? usernameValidator(String? value) {
  if (value!.isEmpty) {
    return "Please provide an unique username";
  }
  if (value.length < 3) {
    return "Username is too short";
  }
  return null;
}

String? emailValidator(String? value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern);
  if (value!.isEmpty) {
    return "Please enter a email";
  } else if (!regex.hasMatch(value)) {
    return 'Email format is invalid';
  }
  return null;
}

String? otherValidator(String? value) {
  if (value!.isEmpty) {
    return "Field is required";
  } else if (value.length < 3) {
    return 'Cannot be too short';
  }
  return null;
}

String? phoneValidator(String? value) {
  if (value!.isEmpty) {
    return "Please enter a phone number";
  }
  if (value.length < 9 || value.length > 11) {
    return "Phone number is invalid";
  }
  return null;
}

String? passwordValidator(String? value) {
  if (value!.isEmpty) {
    return "Please enter a password";
  } else if (value.length < 8) {
    return 'Minimum 8 characters';
  } else if (value.length > 16) {
    return 'Maximum 16 characters';
  }
  else if(value.isAlphabetOnly)
    {
      return 'Choose Strong password, add numbers too';
    }
  return null;
}

String? countryValidator(String? value) {
  if (value!.isEmpty) {
    return "Select your country";
  }
  return null;
}

String? commentsValidator(String? value) {
  if (value!.isEmpty) {
    return "Comment is empty!";
  }
  if (value.length < 5) {
    return "Comment is too short!";
  }
  return null;
}

String? genderValidator(String? value) {
  if (value!.isEmpty) {
    return "Gender is required";
  }
  return null;
}


String? dobValidator(String? value) {
  if (value!.isEmpty) {
    return "Date if Birth is required";
  }
  return null;
}


String? fieldValidator(String? value) {
  if (value!.isEmpty) {
    return "Field is required";
  }
  return null;
}
