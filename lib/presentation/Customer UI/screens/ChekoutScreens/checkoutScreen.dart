import 'package:flutter/material.dart';
import 'package:mfc/Constants/colors.dart';
import 'package:mfc/presentation/Customer%20UI/screens/ChekoutScreens/common/checkoutCustomTextField.dart';

class checkoutScreen extends StatefulWidget {
  const checkoutScreen({super.key});

  @override
  State<checkoutScreen> createState() => _checkoutScreenState();
}

class _checkoutScreenState extends State<checkoutScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Checkout Screen',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Color(0xff570101),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              color: secondaryColor,
              shape: const ContinuousRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Icon(Icons.person),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Customer Details',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: primaryColor),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: checkoutCustomTextField(labletext: 'Full Name'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: checkoutCustomTextField(labletext: 'Phone Number'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: checkoutCustomTextField(
                        labletext: 'Email Address (optional)'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child:
                        checkoutCustomTextField(labletext: 'Delivery Address'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              color: secondaryColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.payments_outlined),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Payment Method'),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        const Icon(Icons.payments_outlined),
                        const SizedBox(
                          width: 10,
                        ),
                        const Text('Select Payment Method'),
                        const SizedBox(
                          width: 20,
                        ),
                        ElevatedButton(
                            style: ButtonStyle(),
                            onPressed: () {},
                            child: Text('Choose')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Card(),
          ],
        ),
      ),
    );
  }
}
