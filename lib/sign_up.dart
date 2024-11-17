//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lognsignup/home.dart';
//import 'package:lognsignup/firebase_auth_implementation/firebase_auth_service.dart';
import 'package:lognsignup/login.dart';
import 'package:lognsignup/service/database.dart';
import 'package:random_string/random_string.dart';
import 'widgets/custom_textfield.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

final TextEditingController nameController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController mobController = TextEditingController();
final TextEditingController passController = TextEditingController();

var _isObscured;

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  // final FirebaseAuthService _auth = FirebaseAuthService();

  @override
  void initState() {
    super.initState();
    _isObscured = true;
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
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          //resizeToAvoidBottomInset: false,
          body: Stack(children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/signup.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Form(
              key: _formKey,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 70.h,
                      ),
                      Text(
                        "Sign Up",
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
                            "Already have an account? ",
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
                                      builder: (context) =>
                                          const LoginScreen()));
                            },
                            child: Text(
                              "Login",
                              style: GoogleFonts.fredoka(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 75.h,
                      ),
                      UserField(
                        controller: nameController,
                        hintText: "Name",
                        textInputType: TextInputType.text,
                        iconName: Icons.person,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Your Name";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      UserField(
                          controller: emailController,
                          hintText: "Email",
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
                        controller: mobController,
                        hintText: "Mobile Number",
                        textInputType: TextInputType.number,
                        iconName: Icons.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Your Mobile Number";
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      UserField(
                        obscureText: _isObscured,
                        controller: passController,
                        hintText: "Password",
                        textInputType: TextInputType.text,
                        iconName: _isObscured != true
                            ? Icons.visibility
                            : Icons.visibility_off,
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
                          onPressed: () async {
                            String Id = randomAlpha(5);
                            if (_formKey.currentState!.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Processing Data')));
                              print("Validated");

                              Map<String, dynamic> employeeInfoMap = {
                                "Name": nameController.text,
                                "Email": emailController.text,
                                "Mobile_Number": mobController.text,
                                "Password": passController.text,
                                "ID": Id,
                              };
                              await DatabaseMethods()
                                  .addEmployeeDetails(employeeInfoMap, Id);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomePage()),
                              );
                              // await DatabaseMethods()
                              //     .addEmployeeDetails(employeeInfoMap, Id)
                              //    ;
                              //_signup();
                            } else {
                              print("Not Validated");
                            }
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all<Color>(Colors.white),
                              foregroundColor:
                                  WidgetStateProperty.all<Color>(Colors.black),
                              shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)))),
                          child: Text("SUBMIT", style: GoogleFonts.fredoka()),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        children: [
                          const Expanded(
                              child: Divider(
                            color: Colors.grey,
                          )),
                          SizedBox(
                            width: 10.h,
                          ),
                          Text(
                              style: GoogleFonts.fredoka(color: Colors.grey),
                              "or sign up via"),
                          SizedBox(
                            width: 10.h,
                          ),
                          const Expanded(
                              child: Divider(
                            color: Colors.grey,
                          ))
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () {},
                          style: ButtonStyle(
                              side: WidgetStateProperty.all(
                                  const BorderSide(color: Colors.black38)),
                              backgroundColor: WidgetStateProperty.all<Color>(
                                  Colors.transparent),
                              foregroundColor:
                                  WidgetStateProperty.all<Color>(Colors.black),
                              shape: WidgetStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)))),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Image(
                                  image: AssetImage("assets/images/Gicon.png"),
                                  height: 15),
                              SizedBox(
                                width: 10.h,
                              ),
                              Text(
                                "Google",
                                style: GoogleFonts.fredoka(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ])),
    );
  }

  // void _signup() async {
  //   //String username = nameController.text;
  //   String email = emailController.text;
  //   String password = passController.text;

  //   User? user = await _auth.signUpWithEmailAndPassword(email, password);

  //   if (user != null) {
  //     print("User is successfully created");
  //   } else
  //     print("Some error occured");
  // }
}
