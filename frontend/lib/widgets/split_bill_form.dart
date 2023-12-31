import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/api/polls_repository.dart';
import 'package:intl/intl.dart';

class SplitBillForm extends StatefulWidget {
  const SplitBillForm({Key? key}) : super(key: key);

  @override
  State<SplitBillForm> createState() => _SplitBillFormState();
}

class _SplitBillFormState extends State<SplitBillForm> {
  final formKey = GlobalKey<FormState>();
  final paymentController = TextEditingController();
  double? tip;

  @override
  // Formatting of the split payment page
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: Container(
              alignment: Alignment.centerLeft,
              width: double.infinity,
              child: IconButton(
                color: Colors.deepPurple[300],
                onPressed: () {
                  Navigator.pop(
                    context,
                  );
                },
                icon: const Icon(Icons.arrow_back_ios),
              ),
            ),
          ),
          // Display how much the dinner cost
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Total Amount Owed For Dinner",
              style: TextStyle(
                color: Colors.black,
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Form that lets the owner input how much they spent on the dinner
          Form(
              key: formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: TextFormField(
                      controller: paymentController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter Dinner Total";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: "Total Dinner Cost",
                        prefixIcon: Icon(Icons.money, color: Colors.black),
                      ),
                    ),
                  ),
                  // Button to split payment after entering dinner amount
                  SizedBox(
                    width: double.infinity,
                    child: RawMaterialButton(
                      fillColor: Colors.deepPurple[300],
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0)),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          final tip = await PollsRepository.split(
                              double.parse(paymentController.text));
                          setState(() {
                            this.tip = tip;
                          });
                        }
                        paymentController.clear();
                      },
                      child: const Text(
                        "Split Payment",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: tip != null,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                          "Payment split:\nTotal tip was ${NumberFormat.simpleCurrency().format(tip ?? 0)}",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                ],
              )),
        ],
      ),
    ));
  }
}
