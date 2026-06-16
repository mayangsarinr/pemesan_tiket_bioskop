import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/app_colors.dart';
import '../utils/app_routes.dart';
import '../widgets/custom_button.dart';

class ScheduleScreen extends StatefulWidget {
  final String movieTitle;

  const ScheduleScreen({Key? key, required this.movieTitle}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  DateTime _selectedDate = DateTime.now();

  // Example fixed showtimes for demo purposes
  final List<String> _showtimes = [
    '10:00',
    '12:30',
    '15:00',
    '17:45',
    '20:15',
    '22:40',
  ];

  List<DateTime> _visibleDates() {
    final now = DateTime.now();
    return List.generate(7, (i) => DateTime(now.year, now.month, now.day + i));
  }

  void _onSelectShowtime(String time) {
    // For now navigate to seat selection route. The route expects
    // arguments; adjust as your `seat_selection` implementation requires.
    Navigator.pushNamed(context, AppRoutes.seatSelection, arguments: {
      'movieTitle': widget.movieTitle,
      'date': _selectedDate.toIso8601String(),
      'time': time,
    });
  }

  @override
  Widget build(BuildContext context) {
    final dates = _visibleDates();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primaryDark,
        title: Text(widget.movieTitle, style: const TextStyle(color: AppColors.textLight)),
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textLight),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text('Choose a date', style: TextStyle(color: AppColors.textLight, fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              SizedBox(
                height: 92,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: dates.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final d = dates[index];
                    final isSelected = d.year == _selectedDate.year && d.month == _selectedDate.month && d.day == _selectedDate.day;

                    return GestureDetector(
                      onTap: () => setState(() => _selectedDate = d),
                      child: Container(
                        width: 72,
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.cardBackground : AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(DateFormat.E().format(d), style: const TextStyle(color: AppColors.textLight)),
                            const SizedBox(height: 6),
                            Text('${d.day}', style: const TextStyle(color: AppColors.textLight, fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Text(DateFormat.MMM().format(d), style: const TextStyle(color: AppColors.lightBlue)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 18),
              const Text('Available times', style: TextStyle(color: AppColors.textLight, fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),

              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3.5,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: _showtimes.length,
                  itemBuilder: (context, index) {
                    final time = _showtimes[index];
                    return GestureDetector(
                      onTap: () => _onSelectShowtime(time),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(time, style: const TextStyle(color: AppColors.textLight, fontWeight: FontWeight.w600)),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 8),
              CustomButton(
                text: 'Continue',
                onPressed: () {
                  // default to first showtime if none selected
                  final time = _showtimes.isNotEmpty ? _showtimes.first : '';
                  _onSelectShowtime(time);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

