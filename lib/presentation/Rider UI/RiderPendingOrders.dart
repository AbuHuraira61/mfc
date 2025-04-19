import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mfc/Constants/colors.dart';
import 'package:mfc/Constants/custom_text.dart';

class RiderPendingOrders extends StatefulWidget {
  const RiderPendingOrders({super.key});

  @override
  State<RiderPendingOrders> createState() => _RiderPendingOrdersState();
}

class _RiderPendingOrdersState extends State<RiderPendingOrders> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CustomText(textName: 'Customer Name :', fontSize: 18),
           Row(
             children: [
               CustomText(textName: 'Address: ', fontSize: 14),
               
             ],
           ),
            CustomText(textName: 'Receiving Amount: ', fontSize: 14),
          Row(
            children: [
              ElevatedButton(onPressed: (){}, child: Text('See Location',style: TextStyle(color: Colors.black),)),
              SizedBox(width: 20,),
               ElevatedButton(onPressed: (){}, child: Text('Mark as Received',style: TextStyle(color: Colors.black),)),
            ],
          ),
        ],
      ),
      ),
      height: Get.height*0.15,
      width: Get.width*0.9,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(20)),
    );
  }
}