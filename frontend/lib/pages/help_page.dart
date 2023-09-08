import 'package:flutter/material.dart';


class HelpButton extends StatefulWidget {
  const HelpButton({Key? key}) : super(key: key);

  @override
  State<HelpButton> createState() => _HelpState();

}

class _HelpState extends State<HelpButton> {

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF045D5D),
      ),
      resizeToAvoidBottomInset: false,
        body: Padding(
            padding: const EdgeInsets.only(top: 32.0),
            child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Help',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
            )
        )
    );
  }
}
