import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hajj_app/helpers/styles.dart';
import 'package:hajj_app/screens/features/profile/change_name.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class EditScreen extends StatefulWidget {
  const EditScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  late String imageUrl = '';
  late String role = '';

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(FirebaseAuth.instance.currentUser!.uid);

    userRef.once().then((DatabaseEvent event) {
      if (mounted) {
        DataSnapshot snapshot = event.snapshot;
        var userData = snapshot.value;
        if (userData != null && userData is Map) {
          // Process the retrieved data
          // print("User data: $userData");
          setState(() {
            imageUrl = userData['imageUrl'] as String? ?? '';
            role = userData['roles'] ?? '';
          });
        } else {
          // Handle cases where data is not available or not in the expected format
          print("No data available or data not in the expected format");
        }
      }
    }).catchError((error) {
      print("Error fetching data: $error");
      // Handle error if needed
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Generate a random string for the image name
      final randomImageName =
          randomAlphaNumeric(20); // Adjust the length as needed

      // Get a reference to the Firebase Storage location with the random image name
      final storage = FirebaseStorage.instance;
      final reference = storage.ref().child(
          'images/${FirebaseAuth.instance.currentUser!.uid}/$randomImageName.jpg');

      // Upload the file to Firebase Storage
      await reference.putFile(File(pickedFile.path));

      // Get the download URL from Firebase Storage
      var imageUrl = await reference.getDownloadURL();

      // Update the user's profile image URL in the Realtime Database
      DatabaseReference userRef = FirebaseDatabase.instance
          .ref()
          .child("users")
          .child(FirebaseAuth.instance.currentUser!.uid);

      await userRef.update({'imageUrl': imageUrl});

      // Update the UI by calling setState with the new image URL
      setState(() {
        imageUrl = imageUrl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Assuming user data structure is similar to the real-time database structure
      String name = user.displayName ?? "";
      String email = user.email ?? "";

      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: ColorSys.primary),
          leading: IconButton(
            icon: const Icon(Iconsax.arrow_left_2),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'My Profile',
            style: textStyle(color: ColorSys.primary),
          ),
          centerTitle: true,
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 30),
              Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey,
                ),
                child: CircleAvatar(
                  radius: 100,
                  backgroundImage:
                      imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                  backgroundColor:
                      imageUrl.isNotEmpty ? Colors.transparent : Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _pickImage,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: ColorSys.darkBlue,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Change Image',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 35),
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EditNameScreen()),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 14.0),
                      child: Row(
                        children: [
                          Text(
                            'Name',
                            style: textStyle(
                                fontSize: 14,
                                color: ColorSys.darkBlue,
                                fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          Text(
                            name,
                            style: textStyle(
                              fontSize: 14,
                            ),
                          ),
                          const Icon(
                            Iconsax.arrow_right_3,
                            color: ColorSys.darkBlue,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  InkWell(
                    onTap: () {
                      // Handle for onTap here
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 14.0),
                      child: Row(
                        children: [
                          Text(
                            'Email',
                            style: textStyle(
                                fontSize: 14,
                                color: ColorSys.darkBlue,
                                fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          const SizedBox(width: 8),
                          Text(
                            email,
                            style: textStyle(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      // Handle if the user is not logged in
      // You might want to redirect the user to the login screen
      return const Scaffold(
        body: Center(
          child: Text('User not logged in!'),
        ),
      );
    }
  }
}
