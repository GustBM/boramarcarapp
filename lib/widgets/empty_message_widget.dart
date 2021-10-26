import 'package:flutter/material.dart';

class EmptyMessage extends StatelessWidget {
  final IconData icon;
  final String messageText;
  final String buttonText;
  final void Function()? buttonFunction;

  EmptyMessage(
      {required this.icon,
      required this.messageText,
      required this.buttonText,
      required this.buttonFunction});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              padding: EdgeInsets.all(10),
              decoration: new BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(50),
              ),
              constraints: BoxConstraints(
                minWidth: 12,
                minHeight: 12,
              ),
              child: Icon(
                icon,
                size: 80,
                color: Colors.white,
              )),
          SizedBox(height: 10),
          Text(
            messageText,
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Lato',
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(onPressed: buttonFunction, child: Text(buttonText)),
        ],
      ),
    );
  }
}
