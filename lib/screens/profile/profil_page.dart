import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // FOTO PROFILE
            const CircleAvatar(
              radius: 55,
              backgroundColor: Color(0xFFE8F5E9),
              child: Icon(
                Icons.person,
                size: 65,
                color: Color.fromARGB(255, 81, 199, 214),
              ),
            ),

            const SizedBox(height: 15),

            // NAMA
            const Text(
              'Febriani',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 5),

            const Text(
              'Surveyor',
              style: TextStyle(
                fontSize: 14,
                color: Color.fromARGB(255, 159, 213, 226),
              ),
            ),

            const SizedBox(height: 30),

            // DATA PROFILE
            _profileItem(
              icon: Icons.person_outline,
              title: 'Nama',
              value: 'Febriani',
            ),

            _profileItem(
              icon: Icons.wc_outlined,
              title: 'Jenis Kelamin',
              value: 'Perempuan',
            ),

            _profileItem(
              icon: Icons.location_city_outlined,
              title: 'Tempat Lahir',
              value: 'Tasikmalaya',
            ),

            _profileItem(
              icon: Icons.calendar_month_outlined,
              title: 'Tanggal Lahir',
              value: '10 Januari 2008',
            ),

            _profileItem(
              icon: Icons.email_outlined,
              title: 'Email',
              value: 'febrispra@gmail.com',
            ),

            _profileItem(
              icon: Icons.phone_outlined,
              title: 'No. Telepon',
              value: '081234567890',
            ),

            _profileItem(
              icon: Icons.password_outlined,
              title: 'Password',
              value: '••••••••',
            ),

            const SizedBox(height: 25),

            // TOMBOL EDIT PROFILE
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Tambahkan halaman edit profile di sini
                },
                icon: const Icon(Icons.edit),
                label: const Text(
                  'Edit Profile',
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

            // LOGOUT
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () {
                  // Tambahkan fungsi logout
                },
                icon: const Icon(Icons.logout),
                label: const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(
                    color: Colors.red,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET DATA PROFILE
  static Widget _profileItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: const Color.fromARGB(255, 45, 175, 207),
            ),
          ),

          const SizedBox(width: 15),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                    fontSize: 15,
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