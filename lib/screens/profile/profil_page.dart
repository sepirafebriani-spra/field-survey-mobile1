import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../routes/app_routes.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // ============================================================
  // API
  // ============================================================
  static const String profilUrl = 'https://sijala.biz.id/api/v1/profile';
  static const String updateProfilUrl =
      'https://sijala.biz.id/api/v1/profil/update';

  // ============================================================
  // DATA
  // ============================================================
  bool isLoading = true;
  bool isSaving = false;
  bool isUploadingPhoto = false;

  String name = '-';
  String email = '-';
  String phone = '-';
  String gender = '-';

  String? photoname;
  Uint8List? profileImage;
  Uint8List? selectedPhoto;

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  // ============================================================
  // TOKEN
  // ============================================================
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    debugPrint('TOKEN ADA: ${token != null && token.isNotEmpty}');
    return token;
  }

  // ============================================================
  // GET PROFILE
  // ============================================================
  Future<void> getProfile() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      final token = await getToken();

      if (token == null || token.isEmpty) {
        throw Exception('Token tidak ditemukan. Silakan login kembali.');
      }

      final response = await http.get(
        Uri.parse(profilUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 20));

      if (response.body.isEmpty) {
        throw Exception('Response server kosong.');
      }

      final data = jsonDecode(response.body);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception(
          data is Map && data['message'] != null
              ? data['message'].toString()
              : 'Gagal mengambil profil',
        );
      }

      dynamic profile;

      if (data is Map && data['data'] is Map) {
        profile = data['data'];
      } else {
        profile = data;
      }

      if (profile is! Map) {
        throw Exception('Format data profil tidak sesuai.');
      }

      final profileName = profile['name']?.toString() ?? '-';
      final profileEmail = profile['email']?.toString() ?? '-';
      final profilePhone = profile['phone']?.toString() ?? profile['no_hp']?.toString() ?? '-';
      final profileGender = profile['gender']?.toString().trim() ?? '';
      final profilePhoto = profile['photo']?.toString().trim() ?? profile['image']?.toString().trim() ?? '';

      String genderResult = '-';
      if (profileGender.toUpperCase() == 'L') {
        genderResult = 'Laki Laki';
      } else if (profileGender.toUpperCase() == 'P') {
        genderResult = 'Perempuan';
      } else if (profileGender.isNotEmpty) {
        genderResult = profileGender;
      }

      if (!mounted) return;

      setState(() {
        name = profileName;
        email = profileEmail;
        phone = profilePhone;
        gender = genderResult;
        photoname = profilePhoto.isEmpty ? null : profilePhoto;
        isLoading = false;
      });

      if (profilePhoto.isNotEmpty) {
        await loadProfileImage(profilePhoto);
      }
    } catch (e) {
      debugPrint('GET PROFILE ERROR: $e');

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengambil profil:\n$e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ============================================================
  // LOAD IMAGE FROM API
  // ============================================================
  Future<void> loadProfileImage(String fileName) async {
    try {
      final token = await getToken();
      if (token == null || token.isEmpty) return;

      final url = fileName.startsWith('http')
          ? fileName
          : 'https://sijala.biz.id/api/image/$fileName';

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': '*/*',
        },
      ).timeout(const Duration(seconds: 20));

      if (response.statusCode == 200 && response.bodyBytes.isNotEmpty) {
        if (!mounted) return;
        setState(() {
          profileImage = response.bodyBytes;
        });
      }
    } catch (e) {
      debugPrint('IMAGE ERROR: $e');
    }
  }

  // ============================================================
  // PICK PHOTO
  // ============================================================
  Future<void> pickPhoto() async {
    if (isUploadingPhoto) return;

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
      );

      if (result == null || result.files.isEmpty) return;

      final file = result.files.single;

      if (file.bytes == null) {
        throw Exception('File gambar tidak bisa dibaca.');
      }

      if (!mounted) return;

      setState(() {
        selectedPhoto = file.bytes;
      });

      await uploadPhoto(file.bytes!, file.name);
    } catch (e) {
      debugPrint('PICK PHOTO ERROR: $e');

      if (!mounted) return;

      setState(() {
        selectedPhoto = null;
        isUploadingPhoto = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memilih foto:\n$e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ============================================================
  // UPLOAD PHOTO
  // ============================================================
  Future<void> uploadPhoto(Uint8List bytes, String fileName) async {
    if (isUploadingPhoto) return;

    setState(() {
      isUploadingPhoto = true;
    });

    try {
      final token = await getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak ditemukan.');
      }

      final request = http.MultipartRequest(
        'POST',
        Uri.parse(updateProfilUrl),
      );

      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] = 'Bearer $token';

      // Mengatasi batasan HTTP Method pada backend Laravel (Spoofing Method)
      request.fields['_method'] = 'PUT';

      if (name != '-') request.fields['name'] = name;
      if (phone != '-') request.fields['phone'] = phone;
      if (gender == 'Laki Laki') {
        request.fields['gender'] = 'L';
      } else if (gender == 'Perempuan') {
        request.fields['gender'] = 'P';
      }

      // Mengirimkan file foto
      request.files.add(
        http.MultipartFile.fromBytes(
          'photo',
          bytes,
          filename: fileName,
        ),
      );

      final streamedResponse =
          await request.send().timeout(const Duration(seconds: 30));
      final response = await http.Response.fromStream(streamedResponse);

      if (response.body.isEmpty) {
        throw Exception('Response upload kosong.');
      }

      final data = jsonDecode(response.body);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception(
          data is Map && data['message'] != null
              ? data['message'].toString()
              : 'Gagal mengupload foto',
        );
      }

      if (!mounted) return;

      setState(() {
        isUploadingPhoto = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Foto berhasil diperbarui'),
          backgroundColor: Colors.green,
        ),
      );

      await getProfile();

      if (!mounted) return;

      setState(() {
        selectedPhoto = null;
      });
    } catch (e) {
      debugPrint('UPLOAD PHOTO ERROR: $e');

      if (!mounted) return;

      setState(() {
        isUploadingPhoto = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal upload foto:\n$e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ============================================================
  // UPDATE PROFILE DATA
  // ============================================================
  Future<bool> updateProfile({
    required String newName,
    required String newPhone,
    required String newGender,
  }) async {
    if (isSaving) return false;

    setState(() {
      isSaving = true;
    });

    try {
      final token = await getToken();
      if (token == null || token.isEmpty) {
        throw Exception('Token tidak ditemukan.');
      }

      final request = http.MultipartRequest(
        'POST',
        Uri.parse(updateProfilUrl),
      );

      request.headers['Accept'] = 'application/json';
      request.headers['Authorization'] = 'Bearer $token';

      // Override Method untuk Laravel API
      request.fields['_method'] = 'PUT';

      request.fields['name'] = newName;
      request.fields['phone'] = newPhone;
      request.fields['gender'] = newGender;

      final streamedResponse =
          await request.send().timeout(const Duration(seconds: 20));
      final response = await http.Response.fromStream(streamedResponse);

      if (response.body.isEmpty) {
        throw Exception('Response server kosong.');
      }

      final data = jsonDecode(response.body);

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception(
          data is Map && data['message'] != null
              ? data['message'].toString()
              : 'Gagal menyimpan profil',
        );
      }

      if (!mounted) return true;

      setState(() {
        name = newName;
        phone = newPhone;

        if (newGender == 'L') {
          gender = 'Laki Laki';
        } else if (newGender == 'P') {
          gender = 'Perempuan';
        }
      });

      return true;
    } catch (e) {
      debugPrint('UPDATE PROFILE ERROR: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan:\n$e'),
            backgroundColor: Colors.red,
          ),
        );
      }

      return false;
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  // ============================================================
  // EDIT PROFILE MODAL
  // ============================================================
  void showEditProfile() {
    final nameController = TextEditingController(
      text: name == '-' ? '' : name,
    );
    final phoneController = TextEditingController(
      text: phone == '-' ? '' : phone,
    );

    String selectedGender = '';
    final oldGender = gender.toLowerCase().trim();

    if (oldGender == 'laki laki' ||
        oldGender == 'laki-laki' ||
        oldGender == 'l') {
      selectedGender = 'L';
    } else if (oldGender == 'perempuan' || oldGender == 'p') {
      selectedGender = 'P';
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 25,
                bottom: MediaQuery.of(context).viewInsets.bottom + 25,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Edit Profil',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Nama',
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Nomor HP',
                        prefixIcon: const Icon(Icons.phone_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    DropdownButtonFormField<String>(
                      value: selectedGender.isEmpty ? null : selectedGender,
                      decoration: InputDecoration(
                        labelText: 'Jenis Kelamin',
                        prefixIcon: const Icon(Icons.wc_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'L',
                          child: Text('Laki Laki'),
                        ),
                        DropdownMenuItem(
                          value: 'P',
                          child: Text('Perempuan'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setModalState(() {
                          selectedGender = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: isSaving
                            ? null
                            : () async {
                                final newName = nameController.text.trim();
                                final newPhone = phoneController.text.trim();

                                if (newName.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Nama tidak boleh kosong'),
                                    ),
                                  );
                                  return;
                                }

                                if (selectedGender.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Pilih jenis kelamin'),
                                    ),
                                  );
                                  return;
                                }

                                final berhasil = await updateProfile(
                                  newName: newName,
                                  newPhone: newPhone,
                                  newGender: selectedGender,
                                );

                                if (!sheetContext.mounted) return;

                                if (berhasil) {
                                  Navigator.pop(sheetContext);
                                  ScaffoldMessenger.of(sheetContext)
                                      .showSnackBar(
                                    const SnackBar(
                                      content: Text('Profil berhasil diperbarui'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2196F3),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isSaving
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Simpan Perubahan',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () => Navigator.pop(sheetContext),
                      child: const Text(
                        'Batal',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ============================================================
  // LOGOUT
  // ============================================================
  Future<void> logout() async {
    final yakin = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Yakin ingin keluar dari akun?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (yakin != true) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');

    if (!mounted) return;
    context.go(AppRoutes.login);
  }

  // ============================================================
  // PROFILE PHOTO WIDGET
  // ============================================================
  Widget profilePhotoWidget() {
    if (selectedPhoto != null) {
      return CircleAvatar(
        radius: 55,
        backgroundImage: MemoryImage(selectedPhoto!),
      );
    }

    if (profileImage != null) {
      return CircleAvatar(
        radius: 55,
        backgroundImage: MemoryImage(profileImage!),
      );
    }

    return const CircleAvatar(
      radius: 55,
      backgroundColor: Color(0xFFE8F0FE),
      child: Icon(
        Icons.person,
        size: 65,
        color: Colors.blue,
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text(
          'Profil',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E6091),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: showEditProfile,
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: getProfile,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Stack(
                      children: [
                        profilePhotoWidget(),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: isUploadingPhoto ? null : pickPhoto,
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                color: Colors.blue,
                                shape: BoxShape.circle,
                              ),
                              child: isUploadingPhoto
                                  ? const Padding(
                                      padding: EdgeInsets.all(9),
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      email,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 25),
                    _profileCard(Icons.person_outline, 'Nama', name),
                    const SizedBox(height: 12),
                    _profileCard(Icons.email_outlined, 'Email', email),
                    const SizedBox(height: 12),
                    _profileCard(Icons.phone_outlined, 'Nomor HP', phone),
                    const SizedBox(height: 12),
                    _profileCard(Icons.wc_outlined, 'Jenis Kelamin', gender),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: showEditProfile,
                        icon: const Icon(Icons.edit),
                        label: const Text(
                          'Edit Profil',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: OutlinedButton.icon(
                        onPressed: logout,
                        icon: const Icon(Icons.logout),
                        label: const Text(
                          'Logout',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // ============================================================
  // PROFILE CARD
  // ============================================================
  Widget _profileCard(IconData icon, String title, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.blue),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}