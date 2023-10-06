import 'package:flutter/material.dart';


class NotifyLocationTimePage extends StatefulWidget {
  const NotifyLocationTimePage({Key? key}) : super(key: key);

  @override
  State<NotifyLocationTimePage> createState() => _NotifyLocationTimePage();

}

class _NotifyLocationTimePage extends State<NotifyLocationTimePage> {

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
                      'Notify Location and Time',
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
