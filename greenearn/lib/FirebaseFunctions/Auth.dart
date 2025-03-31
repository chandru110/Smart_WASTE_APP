import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignupFirebase {
  static Future<AuthResponse> signup(
      String emailAddress, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      return AuthResponse(success: true, message: 'Signup successful');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return AuthResponse(
            success: false, message: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        return AuthResponse(
            success: false,
            message: 'The account already exists for that email.');
      }
      return AuthResponse(
          success: false, message: e.message ?? 'An error occurred.');
    } catch (e) {
      return AuthResponse(success: false, message: 'Something went wrong: $e');
    }
  }
}

class SigninFirebase {
  static Future<AuthResponse> signin(
      String emailAddress, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      return AuthResponse(success: true, message: 'Signin successful');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return AuthResponse(
            success: false, message: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        return AuthResponse(
            success: false, message: 'Wrong password provided.');
      }
      return AuthResponse(
          success: false, message: e.message ?? 'An error occurred.');
    } catch (e) {
      return AuthResponse(success: false, message: 'Something went wrong: $e');
    }
  }
}

class PasswordResetFirebase {
  static Future<AuthResponse> resetPassword(String emailAddress) async {
    try {
      // Step 1: Send the password reset email
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailAddress);

      // Step 2: You can store the new password locally if you need it for further usage.
      // Note: In practice, the user would need to reset the password via the email link sent to them.
      // Firebase does not allow directly setting the new password without the user following the link.

      // Store the new password if needed (For example purposes, you might store it locally here)
      // String storedPassword = newPassword;

      return AuthResponse(
          success: true,
          message:
              'Password reset email sent. Please check your email to reset your password.');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return AuthResponse(
            success: false, message: 'No user found for that email.');
      }
      return AuthResponse(
          success: false, message: e.message ?? 'An error occurred.');
    } catch (e) {
      return AuthResponse(success: false, message: 'Something went wrong: $e');
    }
  }
}

class GoogleSigninFirebase {
  static Future<AuthResponse> googleSignIn() async {
    try {
      // Step 1: Trigger the Google Sign-In process
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Step 2: Check if the user canceled the Google Sign-In process
      if (googleUser == null) {
        return AuthResponse(
            success: false, message: 'Google sign-in canceled.');
      }

      // Step 3: Retrieve Google authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Step 4: Create a credential for Firebase authentication
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      // Step 5: Sign in with the credential in Firebase
      await FirebaseAuth.instance.signInWithCredential(credential);

      return AuthResponse(success: true, message: 'Google sign-in successful');
    } on FirebaseAuthException catch (e) {
      return AuthResponse(
        success: false,
        message: 'Firebase auth error: ${e.message}',
      );
    } catch (e) {
      return AuthResponse(
        success: false,
        message: 'Something went wrong: $e',
      );
    }
  }
}

class AuthResponse {
  final bool success;
  final String? message;

  AuthResponse({required this.success, this.message});
}
