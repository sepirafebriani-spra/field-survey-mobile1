import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController(
    text: 'Febriani',
  );

  final tempatLahirController = TextEditingController(
    text: 'Tasikmalaya',
  );

  final tanggalLahirController = TextEditingController(
    text: '10 Januari 2008',
  );

  final emailController = TextEditingController(
    text: 'febrispra@gmail.com',
  );

  final phoneController = TextEditingController(
    text: '081234567890',
  );

  final passwordController = TextEditingController();

  String jenisKelamin = 'Perempuan';

  bool showPassword = false;

  @override
  void dispose() {
    nameController.dispose();
    tempatLahirController.dispose();
    tanggalLahirController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // FOTO PROFILE
              const CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xFFE8F5E9),
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: Color.fromARGB(255, 81, 199, 214),
                ),
              ),

              const SizedBox(height: 10),

              TextButton.icon(
                onPressed: () {
                  // Fungsi ganti foto bisa ditambahkan nanti
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text('Ubah Foto'),
              ),

              const SizedBox(height: 20),

              // NAMA
              _inputField(
                controller: nameController,
                label: 'Nama',
                icon: Icons.person_outline,
              ),

              const SizedBox(height: 15),

              // JENIS KELAMIN
              DropdownButtonFormField<String>(
                value: jenisKelamin,
                decoration: InputDecoration(
                  labelText: 'Jenis Kelamin',
                  prefixIcon: const Icon(
                    Icons.wc_outlined,
                    color: Color.fromARGB(255, 45, 175, 207),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Laki-laki',
                    child: Text('Laki-laki'),
                  ),
                  DropdownMenuItem(
                    value: 'Perempuan',
                    child: Text('Perempuan'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    jenisKelamin = value!;
                  });
                },
              ),

              const SizedBox(height: 15),

              // TEMPAT LAHIR
              _inputField(
                controller: tempatLahirController,
                label: 'Tempat Lahir',
                icon: Icons.location_city_outlined,
              ),

              const SizedBox(height: 15),

              // TANGGAL LAHIR
              TextFormField(
                controller: tanggalLahirController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Tanggal Lahir',
                  prefixIcon: const Icon(
                    Icons.calendar_month_outlined,
                    color: Color.fromARGB(255, 45, 175, 207),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
                onTap: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2008, 1, 10),
                    firstDate: DateTime(1950),
                    lastDate: DateTime.now(),
                  );

                  if (selectedDate != null) {
                    setState(() {
                      tanggalLahirController.text =
                          '${selectedDate.day} '
                          '${_monthName(selectedDate.month)} '
                          '${selectedDate.year}';
                    });
                  }
                },
              ),

              const SizedBox(height: 15),

              // EMAIL
              _inputField(
                controller: emailController,
                label: 'Email',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 15),

              // NO TELEPON
              _inputField(
                controller: phoneController,
                label: 'No. Telepon',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),

              const SizedBox(height: 15),

              // PASSWORD
              TextFormField(
                controller: passwordController,
                obscureText: !showPassword,
                decoration: InputDecoration(
                  labelText: 'Password Baru',
                  hintText: 'Kosongkan jika tidak ingin mengubah',
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: Color.fromARGB(255, 45, 175, 207),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      showPassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // TOMBOL SIMPAN
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Profile berhasil diperbarui!',
                          ),
                        ),
                      );

                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.save),
                  label: const Text(
                    'Simpan Perubahan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color.fromARGB(255, 81, 208, 240),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // BATAL
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Batal',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
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

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          color: const Color.fromARGB(255, 45, 175, 207),
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label tidak boleh kosong';
        }
        return null;
      },
    );
  }

  String _monthName(int month) {
    const months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];

    return months[month - 1];
  }
}