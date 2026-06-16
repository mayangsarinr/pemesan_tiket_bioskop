import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/app_colors.dart';
import '../utils/app_routes.dart';
import '../widgets/custom_button.dart';

class SeatSelectionScreen extends StatefulWidget {
  final String movieTitle;
  final String date; // ISO string
  final String time;

  const SeatSelectionScreen({Key? key, required this.movieTitle, required this.date, required this.time}) : super(key: key);

  @override
  State<SeatSelectionScreen> createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  final int seatsPerRow = 8;
  final List<String> rows = ['A','B','C','D','E','F','G','H'];
  final Set<String> selected = {}; 
  late final Set<String> occupied;

  final int pricePerSeat = 50000; // sample price

  @override
  void initState() {
    super.initState();
    occupied = _generateOccupiedSeats();
  }

  Set<String> _generateOccupiedSeats() {
    // Deterministic pseudo-occupied seats based on input args
    final key = '${widget.movieTitle}-${widget.date}-${widget.time}';
    final hash = key.codeUnits.fold<int>(0, (p, c) => p + c);

    final s = <String>{};
    for (int i = 0; i < 10; i++) {
      final r = rows[(hash + i) % rows.length];
      final n = ((hash + i) % seatsPerRow) + 1;
      s.add('$r$n');
    }
    return s;
  }

  void _toggleSeat(String id) {
    if (occupied.contains(id)) return;
    setState(() {
      if (selected.contains(id)) selected.remove(id);
      else if (selected.length < 6) selected.add(id); // max 6 seats
    });
  }

  String _formatCurrency(int value) {
    final f = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return f.format(value);
  }

  void _proceedBooking() {
    if (selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pilih minimal 1 kursi')));
      return;
    }

    final total = selected.length * pricePerSeat;
    Navigator.pushNamed(context, AppRoutes.booking, arguments: {
      'movieTitle': widget.movieTitle,
      'date': widget.date,
      'time': widget.time,
      'seats': selected.toList(),
      'total': total,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        title: Text('Select Seats', style: const TextStyle(color: AppColors.textLight)),
        iconTheme: const IconThemeData(color: AppColors.textLight),
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.movieTitle, style: const TextStyle(color: AppColors.textLight, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text('${widget.date.split('T').first} • ${widget.time}', style: const TextStyle(color: AppColors.lightBlue)),
              const SizedBox(height: 18),

              // Screen indicator
              Center(
                child: Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(8)),
                  alignment: Alignment.center,
                  child: const Text('SCREEN', style: TextStyle(color: AppColors.textLight, fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 18),

              // Seat grid
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: rows.map((r) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          children: [
                            SizedBox(width: 28, child: Text(r, style: const TextStyle(color: AppColors.textLight))),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: seatsPerRow,
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 8,
                                  childAspectRatio: 1.2,
                                  mainAxisSpacing: 8,
                                  crossAxisSpacing: 8,
                                ),
                                itemBuilder: (context, i) {
                                  final id = '$r${i+1}';
                                  final isOccupied = occupied.contains(id);
                                  final isSelected = selected.contains(id);

                                  Color bg;
                                  Color txtColor;
                                  if (isOccupied) {
                                    bg = AppColors.grey;
                                    txtColor = Colors.white;
                                  } else if (isSelected) {
                                    bg = AppColors.lightBlue;
                                    txtColor = AppColors.textDark;
                                  } else {
                                    bg = AppColors.cardBackground;
                                    txtColor = AppColors.textLight;
                                  }

                                  return GestureDetector(
                                    onTap: () => _toggleSeat(id),
                                    child: Container(
                                      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(6)),
                                      alignment: Alignment.center,
                                      child: Text('${i+1}', style: TextStyle(color: txtColor, fontWeight: FontWeight.w600)),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${selected.length} seats', style: const TextStyle(color: AppColors.textLight, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 6),
                        Text(_formatCurrency(selected.length * pricePerSeat), style: const TextStyle(color: AppColors.lightBlue, fontWeight: FontWeight.bold, fontSize: 16)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 160,
                    child: CustomButton(
                      text: 'Continue',
                      onPressed: _proceedBooking,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
