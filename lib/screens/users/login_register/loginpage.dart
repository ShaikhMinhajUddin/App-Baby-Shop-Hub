import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drawer/consts/consts.dart';
import 'package:drawer/screens/admin/admin_home.dart';
import 'package:drawer/screens/users/login_register/registerpage.dart';
import 'package:drawer/screens/users/Home_Screen/home.dart';
import 'package:drawer/services/auth_hepler.dart';
import 'package:drawer/screens/users/user_widget/beveled_button.dart';
import 'package:drawer/services/validation_services.dart';
import 'package:flutter/material.dart';
import 'forgot_password_page.dart'; // Import ForgotPasswordPage

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isObscure = true; // For password visibility
  bool isLoding = false;
  final AuthenticationHelper authenticationHelper = AuthenticationHelper();

  void login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      isLoding = true;
    });

    await authenticationHelper
        .signIn(email: emailController.text, password: passwordController.text)
        .then((value) async {
      if (value != null) {
        String userId = value.user!.uid;

        DocumentSnapshot userDoc =
            await firestore.collection(userCollection).doc(userId).get();

        if (userDoc.exists) {
          String role = userDoc['role'];

          setState(() {
            currentUser = value.user;
          });

          if (role == 'Admin') {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const AdminHome()));
          } else {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const Home()));
          }
        }
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Login Successful')));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Login Failed')));
      }
    });

    setState(() {
      isLoding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,
                color: Colors.black), // Change icon if needed
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Home()));
            },
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Welcome Back!",
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  "Log in to your account to continue",
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                const SizedBox(height: 40),
                Column(
                  children: [
                    // Email input with bottom border
                    TextFormField(
                      controller: emailController,
                      validator: validateEmail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        hintText: "Enter Your Email",
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Password field with eye icon to toggle visibility
                    TextFormField(
                      controller: passwordController,
                      obscureText: isObscure,
                      validator: validatePassword,
                      decoration: InputDecoration(
                        labelText: "Password",
                        hintText: "Enter Your Password",
                        suffixIcon: IconButton(
                          icon: Icon(
                            isObscure ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              isObscure = !isObscure;
                            });
                          },
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: isLoding
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : BeveledButton(
                              title: 'Login',
                              onTap: login,
                              width: MediaQuery.of(context).size.width,
                            ),
                    ),
                    const SizedBox(height: 10),
                    // Forgot Password Button
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Navigate to Forgot Password Page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ForgotPasswordPage(),
                            ),
                          );
                        },
                        child: const Text(
                          "Forgot Password?",
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RegisterPage()));
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
