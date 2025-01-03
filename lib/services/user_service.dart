

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class UserService {
  String endPoint = "https://jsonplaceholder.typicode.com/users";
  final dio = Dio();

  Future<List<User>> getUsers() async {
    List<User> users = [];
    try {
      Response response = await dio.get(endPoint);
      debugPrint(response.data.toString());
      var data = response.data;
      var cachedData = jsonEncode(data);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("userData" , cachedData);
      data.forEach((json) {
        User user = User.fromJson(json);
        users.add(user);
      });
      debugPrint(response.data.toString());
    } catch (e) {
      print(e);
    }
    return users;
  }

 Future editUser(String name , String user , String email) async {
    var data = {
      "name": "$name",
      "username": "$user",
      "email": "$email",
    };
    try {
      Response response = await dio.put(endPoint, data: data);
      print(response.data);
      print(response.statusMessage);
    } catch (e) {
      print(e);
    }
  }

  Future deleteUser(int id) async {
    try {
      Response response = await dio.delete(
        endPoint,
        queryParameters: {'id': "$id"},
      );
      print("response.data");
      print(response.data);
    } catch (e) {
      print(e);
    }
  }

  postUser(String name , String user , String email) async {
    var data = {
      "name": "$name",
      "username": "$user",
      "email": "$email",
    };
    try {
      Response response = await dio.post(endPoint, data: data);
      print(response.data);
      print(response.statusMessage);
    } catch (e) {
      print(e);
    }
  }
}
