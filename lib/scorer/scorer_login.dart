import 'package:flutter/material.dart';
import 'package:score_card/scorer/scorer.dart';
import 'package:velocity_x/velocity_x.dart';

import '../common_things/button.dart';
import '../common_things/colors.dart';

class ScorerLoginPage extends StatefulWidget {
  const ScorerLoginPage({super.key});

  @override
  State<ScorerLoginPage> createState() => _ScorerLoginPageState();
}

class _ScorerLoginPageState extends State<ScorerLoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    50.heightBox,
                    "Login"
                        .text
                        .size(24)
                        .color(MyColors.primaryColor)
                        .fontWeight(FontWeight.w700)
                        .makeCentered(),
                    48.heightBox,
                    "Email".text.make(),
                    8.heightBox,
                    VxTextField(
                      controller: emailController,
                      fillColor: Colors.transparent,
                      borderColor: MyColors.primaryColor,
                      borderType: VxTextFieldBorderType.roundLine,
                      borderRadius: 10,
                      prefixIcon: const Icon(Icons.email_outlined,
                          color: MyColors.primaryColor),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Email is empty.";
                        }
                        return null;
                      },
                    ),
                    20.heightBox,
                    "Password".text.make(),
                    8.heightBox,
                    VxTextField(
                      controller: passwordController,
                      isPassword: true,
                      fillColor: Colors.transparent,
                      borderColor: MyColors.primaryColor,
                      borderType: VxTextFieldBorderType.roundLine,
                      borderRadius: 10,
                      prefixIcon: const Icon(Icons.lock_outlined,
                          color: MyColors.primaryColor),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Password is empty";
                        }
                        return null;
                      },
                    ),
                    10.heightBox,
                    CommonButton(
                        title: "Login",
                        onPressed: () {
                         if (_formKey.currentState!.validate() || emailController == "email" &&
                                 passwordController == "password") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ScorerPage()));

                         }
                        }),
                    20.heightBox,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
