import 'package:flutter/material.dart';
import 'package:flutter_application_febri/data/survey_data.dart';
import '../../models/survey_data.dart';

class SurveyPage extends StatefulWidget {
  final Function(SurveyData) onSurveySaved;

  const SurveyPage({
    super.key,
    required this.onSurveySaved,
  });

  @override
  State<SurveyPage> createState() => _SurveyPageState();
}
class _SurveyPageState extends State<SurveyPage> {
  final namaController = TextEditingController();
  final lokasiController = TextEditingController();
  final hasilController = TextEditingController();

  @override
  void dispose() {
    namaController.dispose();
    lokasiController.dispose();
    hasilController.dispose();
    super.dispose();
  }

  void simpanSurvey() {
    if (namaController.text.isEmpty ||
        lokasiController.text.isEmpty ||
        hasilController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua data harus diisi'),
        ),
      );
      return;
    }

    final survey = SurveyData(
      nama: namaController.text,
      lokasi: lokasiController.text,
      tanggal: DateTime.now().toString().substring(0, 10),
      hasil: hasilController.text,
    );

    widget.onSurveySaved(survey);

    namaController.clear();
    lokasiController.clear();
    hasilController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Survey berhasil disimpan'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Input Survey',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          TextField(
            controller: namaController,
            decoration: const InputDecoration(
              labelText: 'Nama Responden',
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: lokasiController,
            decoration: const InputDecoration(
              labelText: 'Lokasi Survey',
              prefixIcon: Icon(Icons.location_on),
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 15),

          TextField(
            controller: hasilController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Hasil Survey',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.description),
              border: OutlineInputBorder(),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: simpanSurvey,
              icon: const Icon(Icons.save),
              label: const Text('Simpan Survey'),
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
}