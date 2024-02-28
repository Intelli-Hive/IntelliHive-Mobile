import 'package:flutter/material.dart';
import 'package:intellihive_mobile_app/Pages/Profile_Page/Welcome_Page/profile_page.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Profil sayfasına otomatik olarak yönlendirme yap
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Profil()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 243, 33, 226),
      child: Center(
        child: Text(
          "ProfilePage",
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}