import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // ==========================================
  // FORM
  // ==========================================

  final _formKey = GlobalKey<FormState>();

  // ==========================================
  // CONTROLLER
  // ==========================================

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Untuk menampilkan / menyembunyikan password
  bool obscurePassword = true;

  // ==========================================
  // AKUN YANG DIIZINKAN
  // ==========================================

  final String emailBenar = 'febri@gmail.com';

  final String passwordBenar = '123456';

  // ==========================================
  // DISPOSE
  // ==========================================

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  // ==========================================
  // FUNGSI LOGIN
  // ==========================================

  void login() {
    // Cek apakah input sudah diisi
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Ambil nilai email dan password
    final email = emailController.text.trim();
    final password = passwordController.text;

    // ==========================================
    // CEK EMAIL DAN PASSWORD
    // ==========================================

    final emailSalah = email != emailBenar;
    final passwordSalah = password != passwordBenar;

    // ==========================================
    // EMAIL & PASSWORD BENAR
    // ==========================================

    if (!emailSalah && !passwordSalah) {
      context.go('/dashboard');

      return;
    }

    // ==========================================
    // EMAIL & PASSWORD SAMA-SAMA SALAH
    // ==========================================

    if (emailSalah && passwordSalah) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Email dan password salah!',
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );

      return;
    }

    // ==========================================
    // HANYA EMAIL YANG SALAH
    // ==========================================

    if (emailSalah) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Email salah!',
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );

      return;
    }

    // ==========================================
    // HANYA PASSWORD YANG SALAH
    // ==========================================

    if (passwordSalah) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Password salah!',
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );

      return;
    }
  }

  // ==========================================
  // TAMPILAN
  // ==========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ========================================
      // APP BAR
      // ========================================

      appBar: AppBar(
        title: const Text(
          'Login',
        ),

        centerTitle: true,

        backgroundColor: Colors.blue,

        foregroundColor: Colors.white,
      ),

      // ========================================
      // BODY
      // ========================================

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),

            child: Form(
              key: _formKey,

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.stretch,

                children: [
                  // ==================================
                  // JARAK ATAS
                  // ==================================

                  const SizedBox(
                    height: 40,
                  ),

                  // ==================================
                  // ICON
                  // ==================================

                  const Icon(
                    Icons.assignment,

                    size: 90,

                    color: Colors.blue,
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  // ==================================
                  // JUDUL
                  // ==================================

                  const Text(
                    'FIELD SURVEY',

                    textAlign: TextAlign.center,

                    style: TextStyle(
                      fontSize: 28,

                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  // ==================================
                  // SUBTITLE
                  // ==================================

                  const Text(
                    'Selamat Datang',

                    textAlign: TextAlign.center,

                    style: TextStyle(
                      fontSize: 16,

                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(
                    height: 40,
                  ),

                  // ==================================
                  // EMAIL
                  // ==================================

                  TextFormField(
                    controller:
                        emailController,

                    keyboardType:
                        TextInputType.emailAddress,

                    decoration:
                        InputDecoration(
                      labelText: 'Email',

                      hintText:
                          'Masukkan email',

                      prefixIcon:
                          const Icon(
                        Icons.email,
                      ),

                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                          12,
                        ),
                      ),

                      enabledBorder:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                          12,
                        ),

                        borderSide:
                            BorderSide(
                          color: Colors
                              .grey
                              .shade300,
                        ),
                      ),

                      focusedBorder:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                          12,
                        ),

                        borderSide:
                            const BorderSide(
                          color: Colors.blue,

                          width: 2,
                        ),
                      ),
                    ),

                    validator: (value) {
                      if (value == null ||
                          value
                              .trim()
                              .isEmpty) {
                        return 'Email wajib diisi';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  // ==================================
                  // PASSWORD
                  // ==================================

                  TextFormField(
                    controller:
                        passwordController,

                    obscureText:
                        obscurePassword,

                    decoration:
                        InputDecoration(
                      labelText:
                          'Password',

                      hintText:
                          'Masukkan password',

                      prefixIcon:
                          const Icon(
                        Icons.lock,
                      ),

                      // Tombol lihat password
                      suffixIcon:
                          IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons
                                  .visibility
                              : Icons
                                  .visibility_off,
                        ),

                        onPressed: () {
                          setState(() {
                            obscurePassword =
                                !obscurePassword;
                          });
                        },
                      ),

                      border:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                          12,
                        ),
                      ),

                      enabledBorder:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                          12,
                        ),

                        borderSide:
                            BorderSide(
                          color: Colors
                              .grey
                              .shade300,
                        ),
                      ),

                      focusedBorder:
                          OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(
                          12,
                        ),

                        borderSide:
                            const BorderSide(
                          color: Colors.blue,

                          width: 2,
                        ),
                      ),
                    ),

                    validator: (value) {
                      if (value == null ||
                          value.isEmpty) {
                        return 'Password wajib diisi';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  // ==================================
                  // TOMBOL LOGIN
                  // ==================================

                  SizedBox(
                    height: 50,

                    child: ElevatedButton(
                      onPressed: login,

                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.blue,

                        foregroundColor:
                            Colors.white,

                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                            15,
                          ),
                        ),
                      ),

                      child: const Text(
                        'LOGIN',

                        style: TextStyle(
                          fontSize: 16,

                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  // ==================================
                  // REGISTER
                  // ==================================

                  TextButton(
                    onPressed: () {
                      context.go(
                        '/register',
                      );
                    },

                    child: const Text(
                      'Belum punya akun? Daftar',
                    ),
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