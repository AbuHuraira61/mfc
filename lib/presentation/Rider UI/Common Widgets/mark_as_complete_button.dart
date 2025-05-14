import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mfc/Constants/colors.dart';

class MarkAsCompleteButton extends StatelessWidget {
  String orderId;
   MarkAsCompleteButton({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return  Expanded(
                                        child: ElevatedButton.icon(
                                          onPressed: () {
                                            Get.defaultDialog(
                                              title: 'Mark as Complete',
                                              titleStyle: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18,
                                              ),
                                              middleText:
                                                  'If order has dilevered successfully then click on yes.',
                                              middleTextStyle: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 14,
                                              ),
                                              backgroundColor: primaryColor,
                                              radius: 16,
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      24, 16, 24, 0),
                                              actions: [
                                                Padding(
                                                  padding: const EdgeInsets.all(20),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Flexible(
                                                        child: ElevatedButton(
                                                          onPressed: () =>
                                                              Get.back(),
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Colors.white,
                                                            foregroundColor:
                                                                primaryColor,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical: 12),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                          ),
                                                          child: Text('No'),
                                                        ),
                                                      ),
                                                      SizedBox(width: 12),
                                                      Expanded(
                                                        child: ElevatedButton(
                                                          onPressed: () async {
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'orders')
                                                                .doc(orderId)
                                                                .update({
                                                              'status': 'Complete'
                                                            });
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'AssignedOrders')
                                                                .doc(orderId)
                                                                .update({
                                                              'status': 'Complete'
                                                            });
                                                            Get.back();
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                Colors.white,
                                                            foregroundColor:
                                                                primaryColor,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical: 12),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                          ),
                                                          child: Text('Yes'),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                              ],
                                            );
                                          },
                                          icon: Icon(Icons.check_circle,
                                              color: primaryColor),
                                          label: Text(
                                            'Accept',
                                            style:
                                                TextStyle(color: primaryColor),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 12),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        ),
                                      );
  }
}