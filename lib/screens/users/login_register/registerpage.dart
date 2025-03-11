import 'package:drawer/consts/consts.dart';
import 'package:drawer/screens/users/login_register/loginpage.dart';
import 'package:drawer/screens/users/Home_Screen/home.dart';
import 'package:drawer/services/auth_hepler.dart';
import 'package:drawer/screens/users/user_widget/beveled_button.dart';
import 'package:drawer/services/validation_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  String selectedRole = "User";
  bool isLoading = false;
  bool showDropdown = false;
  bool isPasswordObscured = true; // For password visibility toggle
  final AuthenticationHelper authenticationHelper = AuthenticationHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,
              color: Colors.black), // Change icon if needed
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => const Home()));
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
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
                  "Sign Up to your account to continue",
                  style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),
                const SizedBox(height: 40),
                Column(
                  children: [
                    // Name field with bottom border
                    TextFormField(
                      controller: nameController,
                      validator: validateName,
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        hintText: 'Enter Name',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Email field with bottom border
                    TextFormField(
                      controller: emailController,
                      validator: validateEmail,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter Email',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Phone number field with bottom border
                    TextFormField(
                      controller: phoneController,
                      validator: validatePhoneNumber,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        hintText: 'Enter Phone Number',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Address field with bottom border
                    TextFormField(
                      controller: addressController,
                      validator: validateAddress,
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        hintText: 'Enter Address',
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Password field with eye icon for visibility toggle
                    TextFormField(
                      controller: passwordController,
                      obscureText: isPasswordObscured,
                      validator: validatePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            isPasswordObscured
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              isPasswordObscured = !isPasswordObscured;
                            });
                          },
                        ),
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (showDropdown)
                      DropdownButtonFormField(
                        value: selectedRole,
                        decoration: const InputDecoration(
                            labelText: 'Role', border: OutlineInputBorder()),
                        items: ["Admin", "User"].map((role) {
                          return DropdownMenuItem(
                            value: role,
                            child: Text(role),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedRole = newValue!;
                          });
                        },
                      ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : BeveledButton(
                              title: 'Sign Up',
                              width: MediaQuery.of(context).size.width,
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    UserCredential? userCredential =
                                        await authenticationHelper.signUp(
                                      email: emailController.text,
                                      password: passwordController.text,
                                    );

                                    if (userCredential != null) {
                                      await authenticationHelper.storeUserData(
                                        name: nameController.text,
                                        email: emailController.text,
                                        password: passwordController.text,
                                        phone: phoneController.text,
                                        address: addressController.text,
                                        role: selectedRole,
                                      );
                                      setState(() {
                                        currentUser = userCredential.user;
                                      });

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text('Signup Successful')),
                                      );

                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const Home()),
                                      );
                                    }
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Signup Failed: ${e.toString()}')),
                                    );
                                  } finally {
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                                }
                              },
                            ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()));
                        },
                        child: const Text(
                          "Login",
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
