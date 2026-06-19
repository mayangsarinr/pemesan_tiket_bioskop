import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_routes.dart';
import '../widgets/custom_button.dart';

class SeatSelectionScreen extends StatefulWidget {
  const SeatSelectionScreen({Key? key}) : super(key: key);

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  final List<String> _selectedSeats = [];
  final List<String> _seatRows = ['A', 'B', 'C', 'D', 'E'];
  final int _seatColumns = 6;

  @override
  Widget build(BuildContext context) {
    final passingData =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final schedule = passingData['schedule'] as Map<String, dynamic>;
    final int pricePerSeat = schedule['price'] ?? 0;
    final int totalPrice = _selectedSeats.length * pricePerSeat;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Pilih Kursi',
            style: TextStyle(color: AppColors.textLight)),
        backgroundColor: AppColors.primaryDark,
        iconTheme: const IconThemeData(color: AppColors.textLight),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 8,
              decoration: BoxDecoration(color: AppColors.lightBlue, boxShadow: [
                BoxShadow(
                    color: AppColors.lightBlue.withOpacity(0.5),
                    blurRadius: 8,
                    spreadRadius: 2)
              ]),
            ),
            const SizedBox(height: 8),
            const Text('LAYAR BIOSKOP',
                style: TextStyle(
                    color: AppColors.grey, fontSize: 12, letterSpacing: 4)),
            const SizedBox(height: 40),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _seatColumns,
                  childAspectRatio: 1,
                ),
                itemCount: _seatRows.length * _seatColumns,
                itemBuilder: (context, index) {
                  int rowIndex = index ~/ _seatColumns;
                  int colIndex = index % _seatColumns + 1;
                  String seatCode = '${_seatRows[rowIndex]}$colIndex';
                  bool isSelected = _selectedSeats.contains(seatCode);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          _selectedSeats.remove(seatCode);
                        } else {
                          _selectedSeats.add(seatCode);
                        }
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.lightBlue
                            : AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.accent),
                      ),
                      child: Center(
                        child: Text(
                          seatCode,
                          style: TextStyle(
                            color: isSelected
                                ? AppColors.primaryDark
                                : AppColors.textLight,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${_selectedSeats.length} Kursi Terpilih',
                    style: const TextStyle(
                        color: AppColors.textLight, fontSize: 16)),
                Text('Rp $totalPrice',
                    style: const TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Lanjutkan Ringkasan',
              onPressed: _selectedSeats.isEmpty
                  ? () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pilih minimal 1 kursi')))
                  : () {
                      Navigator.pushNamed(context, AppRoutes.booking,
                          arguments: {
                            ...passingData,
                            'selectedSeats': _selectedSeats,
                            'totalPrice': totalPrice,
                          });
                    },
            ),
          ],
        ),
      ),
    );
  }
}
