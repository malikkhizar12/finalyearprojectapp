import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

String handleExceptionError(error) {
  if (error is PlatformException) {
    switch (error.code) {
      case 'ERROR_OPERATION_NOT_ALLOWED':
        return 'Google sign-in is not enabled';
      case 'ERROR_INVALID_CREDENTIAL':
        return 'The provided Google ID token is invalid';
      case 'ERROR_NETWORK_REQUEST_FAILED':
        return 'A network error occurred during the request';
      case 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL':
        return 'An account already exists with the same email address but different sign-in credentials';
      case 'ERROR_INVALID_EMAIL':
        return 'The email address is badly formatted';
      case 'ERROR_WRONG_PASSWORD':
        return 'The password is invalid';
      case 'ERROR_TOO_MANY_REQUESTS':
        return 'There were too many requests from this device, rate limiting has been applied';
      case 'ERROR_USER_DISABLED':
        return 'The user account has been disabled';
      case 'ERROR_USER_NOT_FOUND':
        return 'There is no user record corresponding to this identifier';
      case 'ERROR_INVALID_ACTION_CODE':
        return 'The action code is invalid';
      case 'ERROR_CANCELED':
        return 'The user canceled the operation';
      case 'ERROR_LOGIN_FAILED':
        return 'Login failed';
      case 'ERROR_NETWORK_ERROR':
        return 'A network error occurred';
      case 'ERROR_PERMISSION_DENIED':
        return 'The user did not grant the required permissions';
      case 'ERROR_APP_NOT_AUTHORIZED':
        return 'The Facebook app is not authorized';
      default:
        return 'An unknown error occurred';
    }
  } else if (error is FirebaseAuthException) {
    switch (error.code) {
      case 'email-already-in-use':
        return 'Email already in use';
      case 'invalid-email':
        return 'Invalid email format';
      case 'weak-password':
        return 'Weak password';
      case 'invalid-credential':
        return 'Invalid credential';
      case 'account-exists-with-different-credential':
        return 'Account already exists with same email';
      case 'network-request-failed':
        return 'Network error';
      case 'wrong-password':
        return 'Incorrect password';
      case 'user-not-found':
        return 'User not found';
      case 'too-many-requests':
        return 'Too many requests';
      case 'user-disabled':
        return 'User disabled';
      case 'operation-not-allowed':
        return 'Operation not allowed';
      default:
        return 'Unknown error';
    }
  }
  return "Something went wrong";
}
