import 'package:flutter/material.dart';

class SurveyPage extends StatefulWidget {
  const SurveyPage({super.key});

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  final namaController = TextEditingController();
  final alamatController = TextEditingController();
  final teleponController = TextEditingController();
  final keteranganController = TextEditingController();

  String? jenisKelamin;

  @override
  void dispose() {
    namaController.dispose();
    alamatController.dispose();
    teleponController.dispose();
    keteranganController.dispose();
    super.dispose();
  }

  void simpanSurvey() {
    if (namaController.text.isEmpty ||
        alamatController.text.isEmpty ||
        teleponController.text.isEmpty ||
        jenisKelamin == null ||
        keteranganController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua data wajib diisi!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Survey berhasil disimpan!'),
        backgroundColor: Colors.green,
      ),
    );

    namaController.clear();
    alamatController.clear();
    teleponController.clear();
    keteranganController.clear();

    setState(() {
      jenisKelamin = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Form Survey',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Silakan isi data survey',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),

          const SizedBox(height: 25),

          // NAMA
          TextField(
            controller: namaController,
            decoration: InputDecoration(
              labelText: 'Nama',
              hintText: 'Masukkan nama',
              prefixIcon: const Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ALAMAT
          TextField(
            controller: alamatController,
            maxLines: 2,
            decoration: InputDecoration(
              labelText: 'Alamat',
              hintText: 'Masukkan alamat',
              prefixIcon: const Icon(Icons.location_on),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // TELEPON
          TextField(
            controller: teleponController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'No. Telepon',
              hintText: 'Masukkan nomor telepon',
              prefixIcon: const Icon(Icons.phone),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // JENIS KELAMIN
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Jenis Kelamin',
              prefixIcon: const Icon(Icons.people),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
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
                jenisKelamin = value;
              });
            },
          ),

          const SizedBox(height: 16),

          // KETERANGAN
          TextField(
            controller: keteranganController,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: 'Keterangan',
              hintText: 'Masukkan keterangan survey',
              prefixIcon: const Icon(Icons.description),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const SizedBox(height: 25),

          // SIMPAN
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: simpanSurvey,
              icon: const Icon(Icons.save),
              label: const Text(
                'SIMPAN SURVEY',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
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
        ],
      ),
    );
  }
}