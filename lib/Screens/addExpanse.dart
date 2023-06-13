import 'package:expense_app/Screens/homePage.dart';
import 'package:expense_app/services/databaseServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddExpanse extends StatefulWidget {
  const AddExpanse({Key? key}) : super(key: key);

  @override
  State<AddExpanse> createState() => _AddExpanseState();
}

class _AddExpanseState extends State<AddExpanse> {

  bool saving = false;
  TextEditingController descController = TextEditingController();
  TextEditingController amountController = TextEditingController();




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add new expanse",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black),),
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: descController,
                  decoration: InputDecoration(
                    isDense:true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Colors.black,width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Colors.black,width: 2),
                    ),
                    hintText: "Expanse desc",
                    hintStyle: TextStyle(color: Colors.grey,fontSize: 14),
                  ),
                ),
                SizedBox(height: 10,),
                TextField(
                  controller: amountController,
                  decoration: InputDecoration(
                    isDense:true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Colors.black,width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(color: Colors.black,width: 2),
                    ),
                    hintText: "Price",
                    hintStyle: TextStyle(color: Colors.grey,fontSize: 14),
                  ),
                ),
                SizedBox(height: 40,),
                Center(
                  child: InkWell(
                    onTap: () async{
                      setState(() {
                        saving = true;
                      });

                      await dataBaseService().addExpanseData(amountController.text.trim(), descController.text.trim(),DateFormat("dd/mm/yy").format(DateTime.now()).toString(), context);

                      setState(() {
                        saving = false;
                      });
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage()), (route) => false);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: Text(
                        "Add Expanse",style: TextStyle(color: Colors.white,fontSize: 16),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
