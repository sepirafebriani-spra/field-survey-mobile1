import 'package:flutter/material.dart';

import '../../data/survey_data.dart';
import '../../models/survey_model.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String formatTanggal(DateTime tanggal) {
    return '${tanggal.day.toString().padLeft(2, '0')}/'
        '${tanggal.month.toString().padLeft(2, '0')}/'
        '${tanggal.year}';
  }

  @override
  Widget build(BuildContext context) {
    final data = SurveyData.data;

    return data.isEmpty
        ? const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Icon(
                  Icons.description_outlined,
                  size: 80,
                  color: Colors.grey,
                ),

                SizedBox(height: 15),

                Text(
                  'Belum ada laporan survey',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  'Hasil survey yang disimpan akan muncul di sini',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          )
        : ListView(
            padding: const EdgeInsets.all(16),

            children: [
              const Text(
                'Laporan Survey',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                '${data.length} laporan survey',
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 20),

              ...data.reversed.map(
                (survey) => _surveyCard(survey),
              ),
            ],
          );
  }

  Widget _surveyCard(SurveyModel survey) {
    return Card(
      margin: const EdgeInsets.only(bottom: 15),

      elevation: 2,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // ==========================
            // HEADER
            // ==========================

            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFFE3F2FD),

                  child: Icon(
                    Icons.person,
                    color: Colors.blue,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,

                    children: [
                      Text(
                        survey.nama,

                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        formatTanggal(
                          survey.tanggal,
                        ),

                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                ),
              ],
            ),

            const Divider(height: 25),

            // ==========================
            // ALAMAT
            // ==========================

            _item(
              Icons.location_on,
              'Alamat',
              survey.alamat,
            ),

            // ==========================
            // TELEPON
            // ==========================

            _item(
              Icons.phone,
              'No. Telepon',
              survey.noTelepon,
            ),

            // ==========================
            // JENIS KELAMIN
            // ==========================

            _item(
              Icons.people,
              'Jenis Kelamin',
              survey.jenisKelamin,
            ),

            // ==========================
            // KETERANGAN
            // ==========================

            _item(
              Icons.description,
              'Keterangan',
              survey.keterangan,
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(
    IconData icon,
    String title,
    String value,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),

      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,

        children: [
          Icon(
            icon,
            color: Colors.blue,
            size: 20,
          ),

          const SizedBox(width: 10),

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

                const SizedBox(height: 2),

                Text(
                  value,

                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
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