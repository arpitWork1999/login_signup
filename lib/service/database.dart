import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:fluttertoast/fluttertoast.dart';
//import 'package:lognsignup/home.dart';

class DatabaseMethods {
  Future addEmployeeDetails(
      Map<String, dynamic> employeeInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("Employee")
        .doc(id)
        .set(employeeInfoMap);
  }

  //getEmployeeDetails() {}
  Future<Stream<QuerySnapshot>> getEmployeeDetails() async {
    return await FirebaseFirestore.instance.collection("Employee").snapshots();
  }

  Future updateEmployeeDetails(
      String id, Map<String, dynamic> updateInfo) async {
    return await FirebaseFirestore.instance
        .collection("Employee")
        .doc(id)
        .update(updateInfo);
  }
  Future deleteEmployeeDetail(
      String id) async {
    return await FirebaseFirestore.instance
        .collection("Employee")
        .doc(id).delete();
  }
}
