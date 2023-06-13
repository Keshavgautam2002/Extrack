import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class dataBaseService{
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> addExpanseData(String amount, String desc,String time, BuildContext context)
  async{
    var map = {
      "amount" : amount,
      "desc" : desc,
      "date" : time,
    };
    
    await firebaseFirestore.collection("admin").doc("expanse").collection("expanseList").add(map).then((value) =>
    {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Data added successfully",style: TextStyle(color: Colors.white),),backgroundColor: Colors.green,)),
    }).onError((error, stackTrace) => {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Something went wrong",style: TextStyle(color: Colors.white),),backgroundColor: Colors.red,)),
    });
  }

  Future<List?> getExpanseData(BuildContext context)
  async{
    List ls = [];
    await firebaseFirestore.collection("admin").doc("expanse").collection("expanseList").get().then((value){
      ls = value.docs;
    });
    return ls;
  }

  Future<void> editSalary(String salary,String name,BuildContext context)
  async{
    var map = {
      "salary" : salary,
      "name" : name,
    };
    await firebaseFirestore.collection("admin").doc("user").set(map).then((value) => {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Salary edited successfully",style: TextStyle(color: Colors.white),),backgroundColor: Colors.green,)),
    }).onError((error, stackTrace) => {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Something went wrong",style: TextStyle(color: Colors.white),),backgroundColor: Colors.red,)),
    });
  }

  Future<String?> getSalary()
  async{
    String? salary;
    await firebaseFirestore.collection("admin").doc("user").get().then((value) {
      salary = value["salary"];
    });
    return salary;
  }
  
  Future<void> deleteRecord()
  async{

    await FirebaseFirestore.instance.collection("admin").doc("expanse").collection("expanseList").snapshots().forEach((element) {
      for(QueryDocumentSnapshot snapshot in element.docs)
        {
          snapshot.reference.delete();
        }
    });
  }
}