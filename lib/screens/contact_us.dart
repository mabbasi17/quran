import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:izdb/config/constants.dart';
import 'package:izdb/widgets/izdb_app_bar.dart';
import 'package:izdb/widgets/izdb_background.dart';
import 'package:izdb/widgets/izdb_drawer.dart';
import 'package:izdb/widgets/izdb_loading.dart';
import 'package:http/http.dart' as http;

class ContactUs extends StatefulWidget {
  const ContactUs({Key? key}) : super(key: key);

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  Map<String, dynamic> formData = {};

  Future sendEmail(form) async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    const serviceId = 'service_3mucemw';
    const templateId = 'template_jdvge2j';
    const userId = 'X2775G6VTYBsM2uoE';
    const accessToken = "WowDel_CPU41gGOF68tFy";
    return http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          "accessToken": accessToken,
          'template_params': form
        }));
  }

  submitForm() async {
    DateTime date = DateTime.now();
    if (_formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });
      bool isFatwa = formData["type"] == "fatwa";
      if (isFatwa) {
        await FirebaseFirestore.instance.collection("fatwa").add({
          "form": {
            "fatwaAntwort": '',
            "fatwaBemerkung": false,
            "fatwaColsed": false,
            "fatwaEndDatum": "",
            "fatwaOrt": "App",
            "fatwaStartDatum": date,
            "fatwaText": formData["content"],
            "fatwaTitel": formData["subject"],
            "fatwaUser": formData["name"],
            "email": formData["email"]
          }
        }).then((value) async {
          _formKey.currentState?.reset();
          setState(() {
            loading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Fatwa sent\nتم إرسال الفتوى بنجاح')));
        });
      } else {
        await FirebaseFirestore.instance
            .collection("forms")
            .add({...formData, "createdAt": date}).then((value) async {
          await sendEmail(formData);
          _formKey.currentState?.reset();
          setState(() {
            loading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Message sent\nتم إرسال الرسالة بنجاح')));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const IZDBDrawer(),
      appBar: const IZDBAppBar(title: "تواصل معنا"),
      body: IZDBBackground(
        child: loading
            ? const IZDBLoading()
            : Form(
                key: _formKey,
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                      vertical: 40.0, horizontal: 40),
                  primary: false,
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return " ";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.name,
                      textAlign: TextAlign.left,
                      onChanged: (value) {
                        formData["name"] = value;
                      },
                      decoration: izdbTextFieldDecoration.copyWith(
                        labelText: "Name الاسم",
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return " ";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.left,
                      onChanged: (value) {
                        formData["email"] = value;
                      },
                      decoration: izdbTextFieldDecoration.copyWith(
                          labelText: "Email الايميل"),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    DropdownButtonFormField(
                      menuMaxHeight: 500,
                      decoration: izdbTextFieldDecoration.copyWith(
                          labelText: "Typ النوع"),
                      alignment: Alignment.topCenter,
                      value: formData["type"],
                      onChanged: (newValue) {
                        setState(() {
                          formData["type"] = newValue!;
                        });
                      },
                      items: const [
                        DropdownMenuItem(
                          value: "nachricht",
                          child: Text('Nachricht رسالة'),
                        ),
                        DropdownMenuItem(
                          value: "fatwa",
                          child: Text('Fatwa فتوى'),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return " ";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.left,
                      onChanged: (value) {
                        formData["subject"] = value;
                      },
                      decoration: izdbTextFieldDecoration.copyWith(
                          labelText: "Betreff الموضوع"),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return " ";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: 10,
                      textAlign: TextAlign.left,
                      onChanged: (value) {
                        formData["content"] = value;
                      },
                      decoration: izdbTextFieldDecoration.copyWith(
                          labelText: "Content المحتوى"),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                        onPressed: submitForm,
                        child: const Text("Senden إرسال")),
                  ],
                ),
              ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: const Icon(Icons.monetization_on),
      // ),
    );
  }
}
