import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mfc/Constants/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckAdressButton extends StatelessWidget {
  String address;
   CheckAdressButton({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    return Expanded(
                                        child: ElevatedButton.icon(
                                          onPressed: () async {
  final query = Uri.encodeComponent(address);
  final googleUrl = 'https://www.google.com/maps/search/?api=1&query=$query';
  print('Launching URL: $googleUrl');

  final uri = Uri.parse(googleUrl);
  try {
    final launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );
    if (!launched) {
      Get.snackbar('Error', 'Could not open Google Maps');
    }
  } catch (e) {
    Get.snackbar('Launch Error', e.toString());
    print('Error launching URL: $e');
  }
},
                                          // onPressed: () async {
                                          //   final query =
                                          //       Uri.encodeComponent(address);
                                          //       print('Launching address: $address');
                                          //   final googleUrl =
                                          //       'https://www.google.com/maps/search/?api=1&query=$query';

                                          //   if (await canLaunchUrl(
                                          //       Uri.parse(googleUrl))) {
                                          //     await launchUrl(
                                          //       Uri.parse(googleUrl),
                                          //       mode: LaunchMode
                                          //           .externalApplication,
                                          //     );
                                          //   } else {
                                          //     Get.snackbar('Error',
                                          //         'Could not open Google Maps');
                                          //   }
                                          // },
                                          icon: Icon(Icons.map,
                                              color: primaryColor),
                                          label: Text(
                                            'Check Address',
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