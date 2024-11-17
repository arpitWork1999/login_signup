import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lognsignup/service/database.dart';
import 'package:lognsignup/widgets/custom_textfield.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobController = TextEditingController();
  Stream? EmployeeStream;

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

  getontheload() async {
    EmployeeStream = await DatabaseMethods().getEmployeeDetails();
    setState(() {});
  }

  @override
  initState() {
    getontheload();
    super.initState();
  }

  Widget allEmployeeDetails() {
    return StreamBuilder(
        stream: EmployeeStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return Column(
                      children: [
                        containerCard(
                          Name: "Name:- " + ds["Name"],
                          Email: "Email:- " + ds["Email"],
                          Password: "Password:- " + ds["Password"],
                          Mobile: "Mobile Number:- " + ds["Mobile_Number"],
                          Id: "Id:- " + ds["ID"],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                      ],
                    );
                  },
                )
              : Container(
                  decoration: BoxDecoration(color: Colors.black),
                );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text("Home Page",
                style: GoogleFonts.fredoka(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 25)),
          ),
          backgroundColor: Colors.blue,
        ),
        body: containerCard());
  }

  Widget containerCard({
    String? Name,
    String? Password,
    String? Email,
    String? Mobile,
    String? Id,
  }) {
    return StreamBuilder(
        stream: EmployeeStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(10, 9, 10, 1),
                      child: Container(
                        width: 320,
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text("Name:- " + ds["Name"]),
                                  Spacer(),
                                  GestureDetector(
                                      onTap: () {
                                        nameController.text = ds["Name"];
                                        emailController.text = ds["Email"];
                                        mobController.text =
                                            ds["Mobile_Number"];
                                        EditEmployeeDeatils(ds["ID"]);
                                      },
                                      child: const Icon(Icons.edit,
                                          color: Colors.orange)),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  GestureDetector(
                                      onTap: () async {
                                        await DatabaseMethods()
                                            .deleteEmployeeDetail(ds["ID"]);
                                      },
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.orange,
                                      ))
                                ],
                              ),
                              Text("Email:- " + ds["Email"]),
                              Text("Password:-" + ds["Password"]),
                              Text(
                                "Mobile Number:- " + ds["Mobile_Number"],
                              ),
                              Text(
                                "Id:- " + ds["ID"],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              : Container(
                  decoration: BoxDecoration(color: Colors.black),
                );
        });
  }

  Future EditEmployeeDeatils(String id) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            content: SingleChildScrollView(
              child: Container(
                width: 400,
                child: Padding(
                  padding:
                      const EdgeInsets.all(10), // Add padding to the container
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(Icons.cancel),
                          ),
                          Text(
                            "Edit Details",
                            style: GoogleFonts.fredoka(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h),
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
                      SizedBox(height: 10.h),
                      UserField(
                        controller: emailController,
                        hintText: "Email",
                        textInputType: TextInputType.emailAddress,
                        iconName: Icons.mail,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Your Email";
                          } else if (!isEmailValid(value)) {
                            return "Please Enter valid Email";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10.h),
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
                      SizedBox(height: 20.h),
                      ElevatedButton(
                        onPressed: () async {
                          Map<String, dynamic> updateInfo = {
                            "Name": nameController.text,
                            "Email": emailController.text,
                            "Mobile_Number": mobController.text,
                            "ID": id
                          };
                          await DatabaseMethods()
                              .updateEmployeeDetails(id, updateInfo)
                              .then((onValue) {
                            Navigator.pop(context);
                          });
                        },
                        child: Text("Save"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ));
}
