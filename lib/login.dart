import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lognsignup/sign_up.dart';
import 'package:lognsignup/widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

final TextEditingController emailController = TextEditingController();
final TextEditingController passController = TextEditingController();

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscured = true; // Initialize to true

  @override
  void initState() {
    super.initState();
  }

  bool isEmailValid(String email) {
    String pattern =
        r'^([a-z0-9_\-\.]+)@[a-z0-9-]+(\.[a-z0-9-]+)*(\.[a-z]{2,3})$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(email)) {
      return false;
    }
    List<String> validDomains = [
      'gmail.com',
      'yopmail.com',
      'yahoo.com',
      'hotmail.com',
      'msn.com',
      'rediffmail.com',
      'mac.com'
    ];
    String domain = email.split('@').last;
    return validDomains.contains(domain);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/images/login.png"),
                    fit: BoxFit.fill)),
          ),
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 210.h,
                        ),
                        Text(
                          "Login",
                          style: GoogleFonts.fredoka(
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Wrap(
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: GoogleFonts.fredoka(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const SignUp()));
                              },
                              child: Text(
                                "Sign Up",
                                style: GoogleFonts.fredoka(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blue),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        UserField(
                            controller: emailController,
                            hintText: "Username/Email",
                            textInputType: TextInputType.text,
                            iconName: Icons.mail,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please Enter Your Email";
                              } else if (!isEmailValid(value)) {
                                return "Please Enter valid Email";
                              }
                              return null;
                            }),
                        SizedBox(
                          height: 5.h,
                        ),
                        UserField(
                          obscureText: _isObscured,
                          controller: passController,
                          hintText: "Password",
                          textInputType: TextInputType.text,
                          iconName: _isObscured
                              ? Icons.visibility_off
                              : Icons.visibility,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Enter Your Password";
                            }
                            return null;
                          },
                          onPressed: () {
                            setState(() {
                              _isObscured = !_isObscured;
                            });
                          },
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Processing Data')));
                                print("Validated");
                              } else {
                                print("Not Validated");
                              }
                            },
                            style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(
                                    Colors.lightBlueAccent.shade200),
                                foregroundColor: WidgetStateProperty.all<Color>(
                                    Colors.black),
                                shape: WidgetStateProperty.all<
                                        RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5)))),
                            child: Text("SUBMIT", style: GoogleFonts.fredoka()),
                          ),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Center(
                          child: Text(
                            "Forgot password? ",
                            style: GoogleFonts.fredoka(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
