import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_flutter/resources/auth_method.dart';
import 'package:instagram_flutter/utils/colors.dart';
import 'package:instagram_flutter/utils/utils.dart';
import 'package:instagram_flutter/widgets/text_field_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void signUpUser() async {
    if (_image == null) {
      showSnackBar("Please select an image", context);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String result = await AuthMethods().signUpUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: _image!,
    );

    setState(() {
      _isLoading = false;
    });

    if (result != "success") {
      showSnackBar(result, context);
    } else {
      showSnackBar("${_usernameController.text} successfully Signup", context);
    }
  }

  void selectImage() async {
    Uint8List image = await pickImage(ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              color: _isLoading ? Colors.black12 : null,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(flex: 2, child: Container()),
                  SvgPicture.asset(
                    "assets/images/ic_instagram.svg",
                    height: 64,
                    colorFilter: const ColorFilter.mode(
                      primaryColor,
                      BlendMode.color,
                    ),
                  ),
                  const SizedBox(height: 64),
                  Stack(
                    children: [
                      _image != null
                          ? CircleAvatar(
                        radius: 64,
                        backgroundImage: MemoryImage(_image!),
                      )
                          : const CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                          "data:image/png;base64,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",
                        ),
                      ),
                      Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(
                            Icons.add_a_photo,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  TextFieldInput(
                    textInputType: TextInputType.name,
                    textEditingController: _usernameController,
                    hintText: "Enter your username",
                  ),
                  const SizedBox(height: 24),
                  TextFieldInput(
                    textInputType: TextInputType.emailAddress,
                    textEditingController: _emailController,
                    hintText: "Enter your email",
                  ),
                  const SizedBox(height: 24),
                  TextFieldInput(
                    textInputType: TextInputType.text,
                    textEditingController: _passwordController,
                    hintText: "Enter your password",
                    isPass: true,
                  ),
                  const SizedBox(height: 24),
                  TextFieldInput(
                    textInputType: TextInputType.text,
                    textEditingController: _bioController,
                    hintText: "Enter your bio",
                  ),
                  const SizedBox(height: 24),
                  InkWell(
                    onTap: signUpUser,
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: const ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4),
                          ),
                        ),
                        color: blueColor,
                      ),
                      child: const Text("Sign up"),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Flexible(flex: 2, child: Container()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                        child: const Text("Already have an account? "),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                          ),
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            Center(
              child: _isLoading ? const CircularProgressIndicator(color: primaryColor,) : null,
            ),
          ],
        ),
      ),
    );
  }
}
