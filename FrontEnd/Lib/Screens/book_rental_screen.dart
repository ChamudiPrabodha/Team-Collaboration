import 'package:flutter/material.dart';
import 'package:govi_arana/services/rental_service.dart';

class BookMachineScreen extends StatefulWidget {
  const BookMachineScreen({super.key});

  @override
  _BookMachineScreenState createState() => _BookMachineScreenState();
}

class _BookMachineScreenState extends State<BookMachineScreen> {
  final _formKey = GlobalKey<FormState>();
  final RentalService service = RentalService();

  late Map machine;

  final userIdController = TextEditingController();
  final startDateController = TextEditingController();
  final endDateController = TextEditingController();
  String paymentMode = 'Card';

  @override
  void dispose() {
    userIdController.dispose();
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    machine = ModalRoute.of(context)!.settings.arguments as Map;
  }

  void submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        final bookingResponse = await service.bookMachine({
          'machineId': machine['id'],
          'userId': userIdController.text,
          'startDate': startDateController.text,
          'endDate': endDateController.text,
          'paymentMode': paymentMode,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(bookingResponse['message'] ?? 'Booking successful'),
          ),
        );

        Navigator.pushNamed(
          context,
          '/payment',
          arguments: {
            'bookingId': bookingResponse['bookingId'],
            'amount': (bookingResponse['booking']['totalCost'] as num).toInt(),
            'totalCost':
                (bookingResponse['booking']['totalCost'] as num).toDouble(),
          },
        );
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Booking failed: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Book ${machine['title']}')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 6,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Price per day: \$${machine['pricePerDay']}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: userIdController,
                    decoration: InputDecoration(
                      labelText: 'User ID',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator:
                        (val) =>
                            val == null || val.isEmpty
                                ? 'User ID is required'
                                : null,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: startDateController,
                    decoration: InputDecoration(
                      labelText: 'Start Date (YYYY-MM-DD)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Start date is required';
                      }
                      final date = DateTime.tryParse(val);
                      if (date == null) return 'Invalid date format';
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: endDateController,
                    decoration: InputDecoration(
                      labelText: 'End Date (YYYY-MM-DD)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'End date is required';
                      }
                      final date = DateTime.tryParse(val);
                      if (date == null) return 'Invalid date format';
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: paymentMode,
                    decoration: InputDecoration(
                      labelText: 'Payment Mode',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: Icon(Icons.payment),
                    ),
                    items:
                        ['Card', 'Cash', 'Online']
                            .map(
                              (mode) => DropdownMenuItem(
                                value: mode,
                                child: Text(mode),
                              ),
                            )
                            .toList(),
                    onChanged: (val) {
                      setState(() {
                        paymentMode = val!;
                      });
                    },
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: submit,
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        'Book Machine',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
