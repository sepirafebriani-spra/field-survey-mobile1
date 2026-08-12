import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String nama = 'Febri';
  String email = 'febri@gmail.com';
  String noHp = '081234567890';
  String jenisKelamin = 'Perempuan';

  // Masih kosong
  String tempatLahir = '';
  String tanggalLahir = '';

  // ================= BUKA EDIT PROFILE =================

  Future<void> bukaEditProfile() async {
    final hasil = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(
          nama: nama,
          email: email,
          noHp: noHp,
          jenisKelamin: jenisKelamin,
          tempatLahir: tempatLahir,
          tanggalLahir: tanggalLahir,
        ),
      ),
    );

    if (hasil != null) {
      setState(() {
        nama = hasil['nama'];
        email = hasil['email'];
        noHp = hasil['noHp'];
        jenisKelamin = hasil['jenisKelamin'];
        tempatLahir = hasil['tempatLahir'];
        tanggalLahir = hasil['tanggalLahir'];
      });
    }
  }

  // ================= LOGOUT =================

  void logout() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Logout',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          content: const Text(
            'Apakah kamu yakin ingin keluar?',
          ),

          actions: [
            // BATAL
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Batal'),
            ),

            // LOGOUT
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                // Kembali ke halaman login
                context.go('/login');
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),

              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  // ================= PROFILE =================

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),

      child: Column(
        children: [
          const SizedBox(height: 10),

          // ================= FOTO PROFILE =================

          const CircleAvatar(
            radius: 55,
            backgroundColor: Color(0xFFE3F2FD),

            child: Icon(
              Icons.person,
              size: 65,
              color: Colors.blue,
            ),
          ),

          const SizedBox(height: 15),

          // ================= NAMA =================

          Text(
            nama,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const Text(
            'Surveyor',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 30),

          // ================= DATA PROFILE =================

          _profileItem(
            Icons.person_outline,
            'Nama',
            nama,
          ),

          _profileItem(
            Icons.email_outlined,
            'Email',
            email,
          ),

          _profileItem(
            Icons.phone_outlined,
            'No. Telepon',
            noHp,
          ),

          _profileItem(
            Icons.people_outline,
            'Jenis Kelamin',
            jenisKelamin,
          ),

          _profileItem(
            Icons.location_city_outlined,
            'Tempat Lahir',
            tempatLahir.isEmpty
                ? '-'
                : tempatLahir,
          ),

          _profileItem(
            Icons.calendar_month_outlined,
            'Tanggal Lahir',
            tanggalLahir.isEmpty
                ? '-'
                : tanggalLahir,
          ),

          const SizedBox(height: 10),

          // ================= EDIT PROFILE =================

          SizedBox(
            width: double.infinity,
            height: 50,

            child: ElevatedButton.icon(
              onPressed: bukaEditProfile,

              icon: const Icon(
                Icons.edit,
              ),

              label: const Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,

                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ================= LOGOUT =================

          SizedBox(
            width: double.infinity,
            height: 50,

            child: OutlinedButton.icon(
              onPressed: logout,

              icon: const Icon(
                Icons.logout,
                color: Colors.red,
              ),

              label: const Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: Colors.red,
                ),

                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= ITEM PROFILE =================

  Widget _profileItem(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      width: double.infinity,

      margin: const EdgeInsets.only(
        bottom: 12,
      ),

      padding: const EdgeInsets.all(15),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(12),

        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),

      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.blue,
            size: 28,
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  value,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
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

// ========================================================
//                     EDIT PROFILE
// ========================================================

class EditProfilePage extends StatefulWidget {
  final String nama;
  final String email;
  final String noHp;
  final String jenisKelamin;
  final String tempatLahir;
  final String tanggalLahir;

  const EditProfilePage({
    super.key,
    required this.nama,
    required this.email,
    required this.noHp,
    required this.jenisKelamin,
    required this.tempatLahir,
    required this.tanggalLahir,
  });

  @override
  State<EditProfilePage> createState() =>
      _EditProfilePageState();
}

class _EditProfilePageState
    extends State<EditProfilePage> {

  late TextEditingController namaController;
  late TextEditingController emailController;
  late TextEditingController noHpController;
  late TextEditingController tempatLahirController;
  late TextEditingController tanggalLahirController;

  late String jenisKelamin;

  @override
  void initState() {
    super.initState();

    namaController =
        TextEditingController(
      text: widget.nama,
    );

    emailController =
        TextEditingController(
      text: widget.email,
    );

    noHpController =
        TextEditingController(
      text: widget.noHp,
    );

    tempatLahirController =
        TextEditingController(
      text: widget.tempatLahir,
    );

    tanggalLahirController =
        TextEditingController(
      text: widget.tanggalLahir,
    );

    jenisKelamin =
        widget.jenisKelamin;
  }

  @override
  void dispose() {
    namaController.dispose();
    emailController.dispose();
    noHpController.dispose();
    tempatLahirController.dispose();
    tanggalLahirController.dispose();

    super.dispose();
  }

  // ================= KALENDER =================

  Future<void> pilihTanggal() async {
    DateTime? tanggal =
        await showDatePicker(
      context: context,

      initialDate:
          DateTime(2008, 2, 23),

      firstDate:
          DateTime(1950),

      lastDate:
          DateTime.now(),

      helpText:
          'Pilih Tanggal Lahir',

      cancelText:
          'Batal',

      confirmText:
          'Pilih',
    );

    if (tanggal != null) {
      setState(() {
        tanggalLahirController.text =
            '${tanggal.day.toString().padLeft(2, '0')}/'
            '${tanggal.month.toString().padLeft(2, '0')}/'
            '${tanggal.year}';
      });
    }
  }

  // ================= SIMPAN PROFILE =================

  void simpanProfile() {
    Navigator.pop(
      context,
      {
        'nama':
            namaController.text.trim(),

        'email':
            emailController.text.trim(),

        'noHp':
            noHpController.text.trim(),

        'jenisKelamin':
            jenisKelamin,

        'tempatLahir':
            tempatLahirController.text.trim(),

        'tanggalLahir':
            tanggalLahirController.text.trim(),
      },
    );
  }

  // ================= INPUT DECORATION =================

  InputDecoration inputDecoration(
    String label,
    IconData icon,
  ) {
    return InputDecoration(
      labelText: label,

      prefixIcon:
          Icon(icon),

      filled: true,

      fillColor:
          Colors.grey.shade100,

      border:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(12),

        borderSide:
            BorderSide.none,
      ),

      focusedBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(12),

        borderSide:
            const BorderSide(
          color: Colors.blue,
          width: 2,
        ),
      ),
    );
  }

  // ================= BUILD EDIT =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.grey.shade100,

      appBar: AppBar(
        title: const Text(
          'Edit Profile',

          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        centerTitle: true,

        backgroundColor:
            Colors.blue,

        foregroundColor:
            Colors.white,
      ),

      body:
          SingleChildScrollView(
        padding:
            const EdgeInsets.all(20),

        child: Column(
          children: [
            const SizedBox(height: 10),

            // ================= FOTO =================

            const CircleAvatar(
              radius: 50,

              backgroundColor:
                  Color(0xFFE3F2FD),

              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.blue,
              ),
            ),

            const SizedBox(height: 25),

            // ================= NAMA =================

            TextFormField(
              controller:
                  namaController,

              decoration:
                  inputDecoration(
                'Nama',
                Icons.person_outline,
              ),
            ),

            const SizedBox(height: 15),

            // ================= EMAIL =================

            TextFormField(
              controller:
                  emailController,

              keyboardType:
                  TextInputType.emailAddress,

              decoration:
                  inputDecoration(
                'Email',
                Icons.email_outlined,
              ),
            ),

            const SizedBox(height: 15),

            // ================= NO HP =================

            TextFormField(
              controller:
                  noHpController,

              keyboardType:
                  TextInputType.phone,

              decoration:
                  inputDecoration(
                'No. Telepon',
                Icons.phone_outlined,
              ),
            ),

            const SizedBox(height: 15),

            // ================= JENIS KELAMIN =================

            DropdownButtonFormField<String>(
              value:
                  jenisKelamin,

              decoration:
                  inputDecoration(
                'Jenis Kelamin',
                Icons.people_outline,
              ),

              items: const [
                DropdownMenuItem(
                  value: 'Laki-laki',
                  child:
                      Text('Laki-laki'),
                ),

                DropdownMenuItem(
                  value: 'Perempuan',
                  child:
                      Text('Perempuan'),
                ),
              ],

              onChanged:
                  (value) {
                if (value != null) {
                  setState(() {
                    jenisKelamin =
                        value;
                  });
                }
              },
            ),

            const SizedBox(height: 15),

            // ================= TEMPAT LAHIR =================

            TextFormField(
              controller:
                  tempatLahirController,

              decoration:
                  inputDecoration(
                'Tempat Lahir',
                Icons.location_city_outlined,
              ),
            ),

            const SizedBox(height: 15),

            // ================= TANGGAL LAHIR =================

            TextFormField(
              controller:
                  tanggalLahirController,

              readOnly: true,

              onTap:
                  pilihTanggal,

              decoration:
                  inputDecoration(
                'Tanggal Lahir',
                Icons.calendar_month_outlined,
              ),
            ),

            const SizedBox(height: 30),

            // ================= SIMPAN =================

            SizedBox(
              width:
                  double.infinity,

              height: 50,

              child:
                  ElevatedButton.icon(
                onPressed:
                    simpanProfile,

                icon:
                    const Icon(
                  Icons.save,
                ),

                label:
                    const Text(
                  'Simpan Perubahan',

                  style:
                      TextStyle(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

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
                      12,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ================= BATAL =================

            SizedBox(
              width:
                  double.infinity,

              height: 50,

              child:
                  OutlinedButton(
                onPressed: () {
                  Navigator.pop(
                    context,
                  );
                },

                child:
                    const Text(
                  'Batal',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}