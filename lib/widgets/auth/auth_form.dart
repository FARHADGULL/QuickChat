import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quick_chat/widgets/pickers/user_image_picker.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthForm extends StatefulWidget {
  const AuthForm(this.submitFn, {super.key});

  final void Function(String email, String userName, String password,
      XFile image, bool isLogin) submitFn;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  var userEmail = '';
  var userName = '';
  var userPassword = '';
  XFile userImageFile = XFile('');

  void _pickedImage(XFile image) {
    userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    //if user is not logged in and userImageFile is null
    //then show snackbar and return from this function
    //without doing anything else
    if (!_isLogin && userImageFile.path.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please pick an image.'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }
    //isValid means all the validators in the form are satisfied
    if (isValid) {
      _formKey.currentState!.save();

      print('User Email: $userEmail');
      print('Username: ${_isLogin ? 'N/A' : userName}');
      print('User Password: $userPassword');
      print('Is Login: $_isLogin');

      //final image = _isLogin ? null : userImageFile!;

      widget.submitFn(
        userEmail.trim(),
        userName.trim(),
        userPassword.trim(),
        userImageFile,
        _isLogin,
      ); //calling the submitFn function which is passed as a parameter to the widget named AuthForm

      //Now we will use these userValues to interact and send our auth request to firebase auth
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Card(
      margin: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (!_isLogin) UserImagePicker(_pickedImage),
                TextFormField(
                  key: const ValueKey('email'),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email address.';
                    }
                    return null;
                  },
                  //keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email address'),
                  onSaved: (userValue) {
                    userEmail = userValue!;
                  },
                ),
                if (!_isLogin)
                  TextFormField(
                    key: const ValueKey('username'),
                    validator: (value) {
                      if (value!.isEmpty || value.length < 4) {
                        return 'Please enter at least 4 characters';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(labelText: 'Username'),
                    onSaved: (userValue) {
                      userName = userValue!;
                    },
                  ),
                TextFormField(
                  key: const ValueKey('password'),
                  validator: (value) {
                    if (value!.isEmpty || value.length < 7) {
                      return 'Password must be at least 7 character long';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  onSaved: (userValue) {
                    userPassword = userValue!;
                  },
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: _trySubmit,
                  child: Text(_isLogin ? 'Login' : 'Signup'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                    });
                  },
                  child: Text(_isLogin
                      ? 'Create new account'
                      : 'I already have an account'),
                ),
                if (!_isLogin)
                  GestureDetector(
                    onTap: () async {
                      try {
                        //TODO: Implement Google Sign In
                        print('Google Sign In');

                        final GoogleSignInAccount? googleUser =
                            await GoogleSignIn().signIn();

                        if (googleUser != null) {
                          final GoogleSignInAuthentication googleAuth =
                              await googleUser.authentication;

                          print('Google User: $googleUser');
                          print('Google Auth: $googleAuth');

                          final credential = GoogleAuthProvider.credential(
                            accessToken: googleAuth.accessToken,
                            idToken: googleAuth.idToken,
                          );

                          final authResult = await FirebaseAuth.instance
                              .signInWithCredential(credential);

                          print('Google Sign In Successful');

                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(authResult.user!.uid)
                              .set({
                            'username': googleUser.displayName ?? '',
                            'email': googleUser.email,
                            'image_url': googleUser.photoUrl ?? '',
                          });

                          print('Google User added to Firestore');
                        } else {
                          print('Google Sign In was canceled');
                        }
                      } catch (error) {
                        print('Error during Google Sign In: $error');
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        border: Border.all(width: 2, color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.g_mobiledata),
                          SizedBox(width: 10),
                          Text('Sign in with Google'),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
