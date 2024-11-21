import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timesheet/api/login_api.dart';
import 'package:timesheet/app/constants.dart';
import 'package:timesheet/provider/data_provider.dart';
import 'package:timesheet/screens/resources/color_constants.dart';


class LoginPage extends StatefulWidget {
  static const routeName = "/loginpage";
  const LoginPage({Key? key}) : super(key: key);
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  //form key
  final _formkey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  var sizedBox = const SizedBox(
    height: 10,
  );

  @override
  void dispose() {
    passwordController.dispose();
    userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dtProvider=Provider.of<DataProvider>(context,);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        physics:const ClampingScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
          minWidth: MediaQuery.of(context).size.width,
          minHeight: MediaQuery.of(context).size.height,
        ),
          child: Form(
            key: _formkey,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration:const BoxDecoration(
              image:DecorationImage(image: AssetImage("assets/images/background.jpg"),fit: BoxFit.cover), 
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: ColorConstant.transparent,
                    radius: 75,
                    child: Image.asset(
                      'assets/images/saisanket.png',
                      height: 150,
                      width: 150,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                   Text("ERP TOOL",style: TextStyle(fontSize: 20,fontFamily: "Domine",fontWeight: FontWeight.bold,color: ColorConstant.mintGreen),),
                   Text(
                    'Timesheet'.toUpperCase(),
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold
                    )
                  ),
                  if(dtProvider.isLoginLoading)
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ),
                  TextFormField(
                    style: const TextStyle(color: Colors.black),
                    autofocus: false,
                    controller: userNameController,
                    keyboardType: TextInputType.text,
                    autofillHints: const ["userName"],
                    decoration: getDecoration("Username"),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ("Please Enter Your Username");
                      }
                      return null;
                    },
                    onSaved: (value) {
                      // userNameController.text = value!;
                    },
                    textInputAction: TextInputAction.next,
                  ),
                  sizedBox,
                  TextFormField(
                    style: const TextStyle(color: Colors.black),
                    autofocus: false,
                    controller: passwordController,
                    keyboardType: TextInputType.text,
                    
                    decoration: getDecoration("Password"),
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
                    onSaved: (value) {
                      // passwordController.text = value!;
                    },
                    textInputAction: TextInputAction.go,
                    obscureText: false,
                  ),
                  sizedBox,
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () {
                          LoginApi.login(context,userNameController
                          .text, passwordController.text);
                        },
                        child: Text("submit".toUpperCase())),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
