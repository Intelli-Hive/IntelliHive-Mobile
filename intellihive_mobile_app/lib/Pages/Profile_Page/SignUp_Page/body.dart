import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intellihive_mobile_app/Pages/Profile_Page/SignUp_Page/social_icon.dart';
import '../../../services/auth_service.dart';
import '../Login_Page/already_have_an_account_check.dart';
import '../Login_Page/background.dart';
import '../Login_Page/login_page.dart';
import '../Login_Page/rounded_button.dart';
import '../Login_Page/rounded_input_field.dart';
import '../Login_Page/rounded_password_field.dart';
import 'or_divider.dart';


class Body extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();

  Body({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Center(
      child: Background(
        child: ListView(
          shrinkWrap: true,
          reverse: true,
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          children: <Widget>[
            SizedBox(
              height: size.height * 0.07,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                "Üye Ol",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            SvgPicture.asset(
              'images/sign_up/signup.svg',
              height: size.height * 0.35,
            ),
            SizedBox(
              height: size.height * 0.008,
            ),
            RoundedInputField(
              controller: _usernameController,
              hintText: "Adınızı Giriniz",
              icon: Icons.person,
            ),
            RoundedInputField(
              controller: _emailController,
              hintText: "Mail Adresinizi Giriniz",
              icon: Icons.mail,
            ),
            RoundedInputField(
              controller: _phoneNumberController,
              hintText: "Telefon Numaranızı Giriniz",
              icon: Icons.phone,
            ),
            RoundedPasswordField(
              controller: _passwordController,
            ),
            RoundedButton(
              text: "Üye Ol",
              press: () => AuthService().singUp(context, username: _usernameController.text.trim(), email: _emailController.text.trim(), phoneNumber: _phoneNumberController.text.trim(), password: _passwordController.text.trim()),
              color: Colors.deepPurpleAccent.withOpacity(0.8),
            ),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.pop(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return Login();
                    },
                  ),
                );
              },
            ),
            OrDivider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SocialIcon(
                  iconSrc: "images/sign_up/facebook.svg",
                  press: () {},
                ),
                SocialIcon(
                  iconSrc: "images/sign_up/twitter.svg",
                  press: () {},
                ),
                SocialIcon(
                  iconSrc: "images/sign_up/google-plus.svg",
                  press: () {},
                ),
              ],
            ),
            SizedBox(
              height: size.height * 0.12,
            ),
          ].reversed.toList(),
        ),
      ),
    );
  }
}




