import 'package:flutter/material.dart';
import 'package:flutter_application_febri/data/survey_data.dart';
import 'package:flutter_application_febri/screens/survey/survey_page.dart';
import '../../models/survey_data.dart';

class LaporanPage extends StatelessWidget {
  final List<SurveyData> surveys;

  const LaporanPage({
    super.key,
    required this.surveys,
  });

  @override
  Widget build(BuildContext context) {
    if (surveys.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.description_outlined,
              size: 70,
              color: Colors.grey,
            ),
            SizedBox(height: 15),
            Text(
              'Belum ada laporan survey',
              style: TextStyle(
                fontSize: 17,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: surveys.length,
      itemBuilder: (context, index) {
        final survey = surveys[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 15),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Color(0xFFE3F2FD),
                      child: Icon(
                        Icons.description,
                        color: Colors.blue,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        survey.nama,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const Divider(height: 25),

                Text(
                  'Lokasi',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),

                Text(
                  survey.lokasi,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  'Tanggal',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),

                Text(
                  survey.tanggal,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  'Hasil Survey',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 4),

                Text(survey.hasil),
              ],
            ),
          ),
        );
      },
    );
  }
}