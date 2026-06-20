import 'dart:convert'; // Untuk encode foto ke Base64 string
import 'dart:io'; // Untuk file sistem lokal
import 'package:flutter/foundation.dart'
    show kIsWeb; // Cek platform web vs mobile
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart'; // Import paket picker kamera/galeri
import '../utils/app_colors.dart';
import '../utils/app_routes.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_textfield.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  bool _isLoading = false;
  final User? _user = FirebaseAuth.instance.currentUser;

  String? _avatarBase64; // Variabel penampung string data gambar
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _fetchUserData() async {
    if (_user != null) {
      try {
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.uid)
            .get();
        if (doc.exists && mounted) {
          final data = doc.data() as Map<String, dynamic>;
          _nameController.text = data['name'] ?? '';
          setState(() {
            _avatarBase64 =
                data['avatarUrl']; // Ambil foto Base64 yang tersimpan (jika ada)
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Gagal mengambil data: $e')));
        }
      }
    }
  }

  // FITUR MEMILIH SUMBER FOTO (KAMERA ATAU GALERI) VIA BOTTOM SHEET
  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: AppColors.lightBlue,
                ),
                title: const Text(
                  'Pilih dari Galeri',
                  style: TextStyle(color: AppColors.textLight),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.camera_alt,
                  color: AppColors.lightBlue,
                ),
                title: const Text(
                  'Ambil Foto dari Kamera',
                  style: TextStyle(color: AppColors.textLight),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // FUNGSI MEMPROSES GAMBAR DARI KAMERA/GALERI & DIUBAH KE TEXT BASE64
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth:
            400, // Kita batasi ukuran agar tidak membebani Firestore document limit
        maxHeight: 400,
        imageQuality: 75, // Kompresi kualitas gambar
      );

      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _avatarBase64 = base64Encode(
            bytes,
          ); // Diubah menjadi teks string murni
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal mengambil gambar: $e')));
    }
  }

  void _actionUpdateProfile() async {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nama tidak boleh kosong')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      if (_user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.uid)
            .update({
              'name': _nameController.text.trim(),
              'avatarUrl':
                  _avatarBase64, // Simpan teks string gambar ke Firestore database
            });
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil berhasil diperbarui')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _actionLogout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.signIn,
      (route) => false,
    );
  }

  // WIDGET UNTUK MERENDER GAMBAR BAIK DARI STR_BASE64 MAUPUN CADANGAN ICON DEFAULT
  Widget _buildAvatar() {
    if (_avatarBase64 != null && _avatarBase64!.isNotEmpty) {
      try {
        return ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Image.memory(
            base64Decode(_avatarBase64!),
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        );
      } catch (_) {
        // Jika decode gagal, kembalikan ke icon bawaan
      }
    }
    return const Icon(Icons.person, size: 50, color: AppColors.primaryDark);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Profil Saya',
          style: TextStyle(color: AppColors.textLight),
        ),
        backgroundColor: AppColors.primaryDark,
        iconTheme: const IconThemeData(color: AppColors.textLight),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // TOMBOL INTERAKTIF AVATAR UNTUK MENGGANTI FOTO
            GestureDetector(
              onTap: _showImagePickerOptions,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.lightBlue,
                    child: _buildAvatar(),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: AppColors.lightBlue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 18,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Ketuk foto untuk mengubah",
              style: TextStyle(
                color: AppColors.grey.withOpacity(0.8),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _user?.email ?? '',
              style: const TextStyle(color: AppColors.grey),
            ),
            const SizedBox(height: 32),
            CustomTextField(
              controller: _nameController,
              labelText: 'Nama Lengkap',
              icon: Icons.person,
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Simpan Perubahan',
              isLoading: _isLoading,
              onPressed: _actionUpdateProfile,
            ),
            const SizedBox(height: 40),
            TextButton.icon(
              onPressed: _actionLogout,
              icon: const Icon(Icons.logout, color: Colors.redAccent),
              label: const Text(
                'Keluar dari Akun',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
