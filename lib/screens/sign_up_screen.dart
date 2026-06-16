import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/app_colors.dart';
import '../utils/app_routes.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _actionRegister() async {
  setState(() => _isLoading = true);

  try {
    UserCredential credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    );

    print('AUTH SUCCESS');
    print('UID: ${credential.user?.uid}');

    if (credential.user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .set({
        'uid': credential.user!.uid,
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
      });

      print('FIRESTORE SUCCESS');
    }

    if (!mounted) return;

    Navigator.pushReplacementNamed(context, AppRoutes.home);
  } on FirebaseAuthException catch (e) {
    print('====================');
    print('FIREBASE AUTH ERROR');
    print('Code: ${e.code}');
    print('Message: ${e.message}');
    print('====================');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Auth Error: ${e.code}\n${e.message}',
        ),
      ),
    );
  } on FirebaseException catch (e) {
    print('====================');
    print('FIREBASE ERROR');
    print('Code: ${e.code}');
    print('Message: ${e.message}');
    print('====================');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Firebase Error: ${e.code}\n${e.message}',
        ),
      ),
    );
  } catch (e, stackTrace) {
    print('====================');
    print('GENERAL ERROR');
    print(e);
    print(stackTrace);
    print('====================');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString()),
      ),
    );
  } finally {
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: AppColors.textLight)),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Buat Akun Baru',
                  style: TextStyle(
                      color: AppColors.textLight,
                      fontSize: 28,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text(
                  'Daftarkan diri Anda untuk menikmati kemudahan CinemaGo.',
                  style: TextStyle(color: AppColors.grey, fontSize: 14)),
              const SizedBox(height: 32),
              CustomTextField(
                  controller: _nameController,
                  labelText: 'Nama Lengkap',
                  icon: Icons.person),
              const SizedBox(height: 16),
              CustomTextField(
                  controller: _emailController,
                  labelText: 'Email',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 16),
              CustomTextField(
                  controller: _passwordController,
                  labelText: 'Password',
                  icon: Icons.lock,
                  obscureText: true),
              const SizedBox(height: 24),
              CustomButton(
                  text: 'Daftar',
                  isLoading: _isLoading,
                  onPressed: _actionRegister),
            ],
          ),
        ),
      ),
    );
  }
}
