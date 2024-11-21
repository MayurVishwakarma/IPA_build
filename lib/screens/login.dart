// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timesheet/api/login_api.dart';
import 'package:timesheet/provider/data_provider.dart';
import 'package:timesheet/screens/resources/color_constants.dart';

class LoginPage extends StatefulWidget {
  static const routeName = "/loginpage";

  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  var sizedBox = const SizedBox(
    height: 10,
  );

  bool _isPasswordVisible = true;
  var sizedbox = const SizedBox(
    height: 15,
  );
  bool valuefirst = false;

  @override
  Widget build(BuildContext context) {
    final dtProvider = Provider.of<DataProvider>(
      context,
    );
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: <Color>[Colors.cyan, Colors.deepPurple])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: dtProvider.isLoginLoading
                  ? const Center(
                      child: Card(
                        elevation: 8,
                        child: Padding(
                          padding: EdgeInsets.all(50.0),
                          child: CircularProgressIndicator(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    )
                  : AutofillGroup(
                      child: Card(
                        color: Colors.white,
                        elevation: 8,
                        child: Form(
                          key: _formkey,
                          child: Column(
                            children: <Widget>[
                              sizedbox,
                              _buildTitel(context),
                              sizedbox,
                              _buildPhoneField(context),
                              _buildPasswordField(context),
                              _buildLogInButton(context),
                              sizedbox,
                            ],
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitel(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 40.0,
      ),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: ColorConstant.transparent,
            radius: 35,
            child: Image.asset(
              'assets/images/saisanket12.png',
              height: 150,
              width: 150,
            ),
          ),
          const Text(
            'Timesheet',
            softWrap: true,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 5),
      child: TextFormField(
          controller: userNameController,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.username],
          validator: (value) {
            if (value!.isEmpty) {
              return ("Please Enter Your Username");
            }
            return null;
          },
          decoration: InputDecoration(
            fillColor: const Color.fromARGB(255, 204, 220, 233),
            filled: true,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            prefixIcon: const Icon(
              Icons.account_circle,
              color: Colors.grey,
            ),
            labelStyle: const TextStyle(color: Colors.grey),
            hintText: 'Username',
            contentPadding: const EdgeInsets.symmetric(vertical: 5),
            // labelText: 'Mobile No.'
          )),
    );
  }

  Widget _buildPasswordField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 5),
      child: TextFormField(
        controller: passwordController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        autofillHints: const [AutofillHints.password],
        validator: (value) {
          RegExp regex = RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("Password is required for Login");
          }
          if (!regex.hasMatch(value)) {
            return ("Please Enter Correct Password");
          }
          return null;
        },
        obscureText: _isPasswordVisible,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color.fromARGB(255, 204, 220, 233),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
          prefixIcon: const Icon(
            Icons.lock,
            color: Colors.grey,
          ),
          // labelText: "Password",
          hintText: "Password",
          labelStyle: const TextStyle(color: Colors.grey),
          alignLabelWithHint: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 5),
          suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                color: Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              }),
        ),
      ),
    );
  }

  Widget _buildLogInButton(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade700,
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            padding: const EdgeInsets.all(20),
          ),
          onPressed: () {
            TextInput.finishAutofillContext();
            // Navigator.pushNamed(context,  CalenderScreen.routeName);
            LoginApi.login(
                context, userNameController.text, passwordController.text);
          },
          child: const Center(
              child: Text(
            "Login",
            style: TextStyle(color: Colors.white),
          )),
        ));
  }
}
