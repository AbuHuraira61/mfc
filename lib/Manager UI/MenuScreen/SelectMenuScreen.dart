import 'package:flutter/material.dart';
import 'package:mfc/Constants/colors.dart';

class SelectMenuScreen extends StatefulWidget {
  const SelectMenuScreen({super.key});

  @override
  State<SelectMenuScreen> createState() => _SelectMenuScreenState();
}

class _SelectMenuScreenState extends State<SelectMenuScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      
      child: Scaffold(
             body: Center(
               child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(secondaryColor),
                      backgroundColor: MaterialStateProperty.all(primaryColor)),
                    onPressed: (){}, child: Padding(

                      padding: const EdgeInsets.symmetric(horizontal: 100),
                      child: Text('Selct Pizza'),
                    )),
                  SizedBox(height: 20,),
                   ElevatedButton(
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all(secondaryColor) ,
                      backgroundColor: MaterialStateProperty.all(primaryColor)),
                    onPressed: (){}, child: Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 100),
                     child: Text('Selct Burger'),
                   )),
                    SizedBox(height: 20,),
                    ElevatedButton(
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(secondaryColor),
                        backgroundColor: MaterialStateProperty.all(primaryColor)),
                      onPressed: (){}, child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 100),
                      child: Text('Selct Desert'),
                    )),
                ],
               ),
             ),

      ));
  }
}