import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_profile_management/models/user_model.dart';
import 'package:user_profile_management/views/user_details.dart';

import '../services/user_service.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  List<User> users = [];
  bool edit = false;
 
  TextEditingController nameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
List<User> cachedUsers =[];
  getUsers() async {
    // await UserService().postUser();

    users = await UserService().getUsers();
    setState(() {});
  }
getCachedData ()async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String data = prefs.getString("userData")?? "";
  var jsonData = jsonDecode(data);
  jsonData.forEach((item){
cachedUsers.add(User.fromJson(item));
  });
  setState(() {
    
  });
  print(data);
}
  @override
  void initState() {
    super.initState();
    getUsers();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.9,
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        getCachedData();

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>  UserDetails(
                                  name: cachedUsers[index].name,
                                  user:cachedUsers[index].username ,
                                  email: cachedUsers[index].email,
                                )));
                      },
                      child: Dismissible(
                        key: Key("${users[index]}"),
                        onDismissed: (direction) {
                          setState(() async {
                            await UserService().deleteUser(users[index].id);
                            users.removeAt(index);
                          });
                        },
                        child: ListTile(
                          leading: const Icon(
                            Icons.person,
                            size: 18,
                            color: Color.fromARGB(255, 202, 133, 214),
                          ),
                          trailing:
                              //Row(
                              // children: [
                              IconButton(
                                  onPressed: () async {
                                    edit = true;
                                    showBottomSheet();
                                    await UserService().editUser(
                                        nameController.text,
                                        userNameController.text,
                                        emailController.text);
                                    setState(() {});
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    size: 22.0,
                                  )),
                          // IconButton(onPressed: (){}, icon:const Icon(Icons.delete_outline
                          //  , size: 22.0,)),

                          //   ],
                          // ),
                          title: Text(
                            users[index].name,
                            style: const TextStyle(
                                color: Colors.purple,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.purple,
            onPressed: () async {
              edit = false;
              showBottomSheet();
              await UserService().postUser(nameController.text,
                  userNameController.text, emailController.text);
            },
            child: Icon(
              Icons.add,
              color: Colors.white,
            )));
  }

  showBottomSheet() {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => Form(
          key: _formKey,
          child: Container(
            color: Color.fromARGB(255, 202, 133, 214),
            height: MediaQuery.of(context).size.height * 0.8,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person), labelText: "Full name"),
                    validator: (value) {
                      // validate The first letter to be capitalized
                      var upper = value![0];
                      if (upper.toUpperCase() != value[0]) {
                        return "The first letter should be capitalized";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: userNameController,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.abc), labelText: "User Name"),
                    validator: (value) {
                      if (value!.length < 2) {
                        return "Your User Name should be more than 2 characters";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email), labelText: "Email"),
                    validator: (value) {
                      if (!value!.contains("@")) {
                        // validate Email contains @
                        return "Your Email should be contain @";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _showDialog();
                          }
                        },
                        child: Text(
                          edit ? "Edit" : "Add",
                          style: TextStyle(
                              fontSize: 19,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )),
                  )
                ],
              ),
            ),
          )),
    );
  }

  // function to show dialog alert
  Future<void> _showDialog() async {
    return showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text("Hi"),
              content:
                  Text(edit ? "Edited successfully" : "Added successfully"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text("Exit"))
              ],
            ));
  }
}
