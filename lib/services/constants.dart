import 'package:flutter/material.dart';

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
  //border without any effects
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32)),
  ),
  //border with an effects
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 1),
    borderRadius: BorderRadius.all(Radius.circular(32)),
  ),
  //on focus
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.lightBlueAccent, width: 2),
    borderRadius: BorderRadius.all(Radius.circular(32)),
  ),
);

const kSearchTextFieldDecoration = InputDecoration(
  border: InputBorder.none,
  icon: Icon(
    Icons.search,
    color: Colors.white70,
    size: 25,
  ),
  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
  hintText: 'phone, name or email',
  hintStyle: TextStyle(
    color: Colors.white70,
  ),
);
