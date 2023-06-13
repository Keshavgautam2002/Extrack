
import 'dart:ffi';

import 'package:expense_app/Screens/login/login.dart';
import 'package:expense_app/services/shimmerService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../services/databaseServices.dart';
import 'addExpanse.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  FirebaseAuth auth = FirebaseAuth.instance;
  String? salary;
  double? expanse = 0.0;
  User? user;
  DatabaseReference? ref;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  TextEditingController salaryController = TextEditingController();
  bool showShimmer = false;
  List? expanseList;


  getUserData()
  async {
    setState(() {
      showShimmer = true;
    });
    salary = await dataBaseService().getSalary();
    print(salary);
    expanseList = await dataBaseService().getExpanseData(context);
    print(expanseList!.length);
    expanse = await findSum(expanseList!);
    setState(() {
      showShimmer = false;
    });
  }


  Future<double?> findSum(List ls)
  async{
    print("called");
    double? sum = 0.0;
    ls.forEach((element) {
      sum = sum! + double.parse(element["amount"]);
    });
    print("end");
    return sum;
  }

  signOut()
  async{
    await auth.signOut();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Successfully Logged out",style: TextStyle(color: Colors.white),),backgroundColor: Colors.green,));
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
  }

  @override
  void initState() {
    user = auth.currentUser;
    getUserData();
    setState(() {

    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ExTrack",style: TextStyle(
          fontSize: 18,color: Colors.black,fontWeight: FontWeight.bold
        ),),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black
        ),

      ),
      drawer: Drawer(
        width: MediaQuery.of(context).size.width*0.6,
        child: Container(
          margin: const EdgeInsets.all(10),
          padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 7),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(user!.photoURL!),
                ),
              ),
              const SizedBox(height: 5,),
              Center(
                child: Text(user!.displayName!,style: const TextStyle(
                    fontWeight: FontWeight.bold,fontSize: 18
                ),),
              ),
              const SizedBox(height: 20,),
              InkWell(
                onTap: (){
                  showDialog(context: context, builder: (context) => Dialog(
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            decoration: InputDecoration(
                              isDense: true,
                              hintText: "Enter your salary here",
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: const BorderSide(color: Colors.black)
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  borderSide: const BorderSide(color: Colors.black)
                              ),

                            ),
                            controller: salaryController,
                          ),
                          const SizedBox(height: 20,),
                          InkWell(
                            onTap: ()async{
                              print("Done");
                              Navigator.pop(context);
                              dataBaseService().editSalary(salaryController.text.trim(), user!.displayName!, context);
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 40,
                              padding: const EdgeInsets.symmetric(horizontal: 11,vertical: 7),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Text("Save",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white),),
                            ),
                          )
                        ],
                      ),
                    ),
                  ));
                },
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.mode_edit_outline_outlined),
                    SizedBox(width: 5,),
                    Text("Edit Your Income")
                  ],
                ),
              ),
              const SizedBox(height: 10,),
              InkWell(
                onTap: ()async{
                  dataBaseService().deleteRecord();
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.remove_circle_outline),
                    SizedBox(width: 5,),
                    Text("Clear Records")
                  ],
                ),
              ),
              const SizedBox(height: 30,),
              Center(
                child: InkWell(
                  onTap: (){
                    signOut();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    padding: const EdgeInsets.all(10),
                    child: const Text("Logout",style: TextStyle(color: Colors.white,fontSize: 16),),
                  ),
                ),
              )

            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(7),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              showShimmer ? ShimmerService().salaryShimmer(context): Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Total Income",style: TextStyle(
                                color: Colors.black,fontWeight: FontWeight.bold,fontSize: 14
                              ),),
                              Text("₹$salary",style: const TextStyle(
                                color: Colors.green,fontWeight: FontWeight.bold,fontSize: 14
                              ),),
                            ],
                          ),
                          Column(
                           crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("Total Expanse",style: TextStyle(
                                color: Colors.black,fontWeight: FontWeight.bold,fontSize: 14
                              ),),
                              Text("₹${expanse!.toString()}",style: TextStyle(
                                color: Colors.red,fontWeight: FontWeight.bold,fontSize: 14
                              ),),
                            ],
                          ),

                        ],
                      ),
                      const SizedBox(height: 15,),
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text("Remaining Income",style: TextStyle(
                                color: Colors.black,fontWeight: FontWeight.bold,fontSize: 14
                            ),),
                            Text("₹${(double.parse(salary!)-expanse!)}",style: TextStyle(
                                color: Colors.black,fontWeight: FontWeight.bold,fontSize: 16
                            ),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              const Text("Your Transection List",style: TextStyle(
                fontSize: 16,fontWeight: FontWeight.bold,color: Colors.blue
              ),),
              const SizedBox(height: 5,),
              showShimmer ? ShimmerService().listShimmer(context): Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: expanseList!.length,
                  itemBuilder: (context,index) => Card(
                    child:Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(text: "Date : ",style: TextStyle(color: Colors.orange)),
                                TextSpan(text: "${expanseList![index]["date"].toString()}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold)),
                              ]
                            )
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(text: "Amount : ",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold)),
                                TextSpan(text: "₹${expanseList![index]["amount"].toString()}/-",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold,color: Colors.red)),
                              ]
                            )
                          ),
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(text: "Description : ",style: TextStyle(color: Colors.orange)),
                                TextSpan(text: "${expanseList![index]["desc"].toString()}",style: TextStyle(fontSize: 13,fontWeight: FontWeight.bold)),
                              ]
                            )
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AddExpanse()));
        },
        child: const Icon(
          Icons.add_chart_outlined
        ),
      ),
    );
  }
}
