import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final noHpController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmasiPasswordController = TextEditingController();

  bool isLoading = false;

  // L = Laki-laki
  // P = Perempuan
  String gender = 'P';

  // ================= REGISTER KE API =================

  Future<void> register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(
          'https://sijala.biz.id/api/v1/register',
        ),
      );

      // Data yang dikirim ke API
      request.fields['name'] = nameController.text.trim();
      request.fields['phone'] = noHpController.text.trim();
      request.fields['email'] = emailController.text.trim();
      request.fields['gender'] = gender;
      request.fields['password'] = passwordController.text;

      // Kirim request
      final response = await request.send();

      // Ambil response dari API
      final responseBody =
          await response.stream.bytesToString();

      debugPrint('STATUS: ${response.statusCode}');
      debugPrint('RESPONSE: $responseBody');

      if (!mounted) return;

      // REGISTER BERHASIL
      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Register berhasil'),
            backgroundColor: Colors.green,
          ),
        );

        await Future.delayed(
          const Duration(milliseconds: 500),
        );

        if (!mounted) return;

        context.go('/login');
      }

      // REGISTER GAGAL
      else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Register gagal: $responseBody',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint('ERROR: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Tidak dapat terhubung ke server: $e',
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    noHpController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmasiPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        title: const Text('Register'),
        centerTitle: true,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 500,
              ),

              child: Padding(
                padding: const EdgeInsets.all(24),

                child: Form(
                  key: _formKey,

                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      const Icon(
                        Icons.person_add,
                        size: 80,
                        color: Color(0xFF6FA8DC),
                      ),

                      const SizedBox(height: 20),

                      const Text(
                        'Buat Akun',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 30),

                      // ================= NAMA =================

                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nama',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
                            return 'Nama wajib diisi';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // ================= NO HP =================

                      TextFormField(
                        controller: noHpController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Nomor HP',
                          hintText: '08xxxxxxxxxx',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
                            return 'Nomor HP wajib diisi';
                          }

                          if (!RegExp(r'^[0-9]+$')
                              .hasMatch(value.trim())) {
                            return 'Nomor HP hanya boleh angka';
                          }

                          if (value.trim().length < 10) {
                            return 'Nomor HP minimal 10 angka';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // ================= EMAIL =================

                      TextFormField(
                        controller: emailController,
                        keyboardType:
                            TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
                            return 'Email wajib diisi';
                          }

                          if (!RegExp(
                            r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                          ).hasMatch(value.trim())) {
                            return 'Format email tidak valid';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // ================= GENDER =================

                      DropdownButtonFormField<String>(
                        value: gender,

                        decoration: const InputDecoration(
                          labelText: 'Jenis Kelamin',
                          border: OutlineInputBorder(),
                          prefixIcon:
                              Icon(Icons.person_outline),
                        ),

                        items: const [
                          DropdownMenuItem(
                            value: 'L',
                            child: Text('Laki-laki'),
                          ),
                          DropdownMenuItem(
                            value: 'P',
                            child: Text('Perempuan'),
                          ),
                        ],

                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              gender = value;
                            });
                          }
                        },
                      ),

                      const SizedBox(height: 16),

                      // ================= PASSWORD =================

                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty) {
                            return 'Password wajib diisi';
                          }

                          if (value.length < 6) {
                            return 'Password minimal 6 karakter';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      // ================= KONFIRMASI =================

                      TextFormField(
                        controller:
                            confirmasiPasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Konfirmasi Password',
                          border: OutlineInputBorder(),
                          prefixIcon:
                              Icon(Icons.lock_outline),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty) {
                            return 'Konfirmasi password wajib diisi';
                          }

                          if (value !=
                              passwordController.text) {
                            return 'Password tidak sama';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      // ================= TOMBOL REGISTER =================

                      SizedBox(
                        width: double.infinity,
                        height: 50,

                        child: ElevatedButton(
                          onPressed:
                              isLoading ? null : register,

                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color(0xFF6FA8DC),
                            foregroundColor: Colors.white,
                          ),

                          child: isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child:
                                      CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Register',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ================= LOGIN =================

                      TextButton(
                        onPressed: () {
                          context.go('/login');
                        },
                        child: const Text(
                          'Sudah punya akun? Login',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}