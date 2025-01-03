import 'package:flutter/material.dart';

class UserDetails extends StatelessWidget {
  String name ;
  String user;
  String email;
   UserDetails({super.key ,required this.name ,required this.user , required this.email});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
         crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name , style:const TextStyle(fontWeight: FontWeight.bold,
            fontSize: 20, color: Colors.purple
            ),),
            Text(user, style:const TextStyle(fontWeight: FontWeight.bold,
            fontSize: 20, color: Colors.purple)),
            Text(email, style:const TextStyle(fontWeight: FontWeight.bold,
            fontSize: 20, color: Colors.purple))
          ],
        ),
      ),
    );
  }
}