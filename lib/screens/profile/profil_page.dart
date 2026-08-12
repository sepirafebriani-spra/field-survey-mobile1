
import'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
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

          const Text(
            'Febri',
            style: TextStyle(
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

          _profileItem(
            Icons.person_outline,
            'Nama',
            'Febri',
          ),

          _profileItem(
            Icons.email_outlined,
            'Email',
            'febri@gmail.com',
          ),

          _profileItem(
            Icons.phone_outlined,
            'No. Telepon',
            '081234567890',
          ),

          _profileItem(
            Icons.cake_outlined,
            'Jenis Kelamin',
            'Perempuan',
          ),

          _profileItem(
            Icons.location_city_outlined,
            'Tempat Lahir',
            'Tasikmalaya',
          ),

          _profileItem(
            Icons.calendar_month_outlined,
            'Tanggal Lahir',
            '23 Februari 2008',
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () {
                // Edit profile
              },
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profile'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileItem(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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

          Column(
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
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

