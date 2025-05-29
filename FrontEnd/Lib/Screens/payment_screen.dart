import 'package:flutter/material.dart';
import 'package:govi_arana/services/rental_service.dart';

class PaymentScreen extends StatefulWidget {
  final String bookingId;
  final double totalCost;

  const PaymentScreen({
    super.key,
    required this.bookingId,
    required this.totalCost,
    required int amount,
  });

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final RentalService service = RentalService();

  String paymentMethod = 'Card';
  String cardType = 'Visa';
  final cardNumberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final Map<String, String> cardImages = {
    'Visa': 'assets/visa.webp',
    'MasterCard': 'assets/mastercard.jpg',
    'Debit': 'assets/debit.webp',
    'Credit': 'assets/credit.webp',
  };

  void submitPayment() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await service.makePayment({
        'bookingId': widget.bookingId,
        'paymentMethod': paymentMethod,
        'amount': widget.totalCost,
        'cardType': paymentMethod == 'Card' ? cardType : null,
        'cardNumber': paymentMethod == 'Card' ? cardNumberController.text : null,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment successful!')),
      );

      // Navigate to dashboard and clear backstack
      Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: $e')),
      );
    }
  }

  @override
  void dispose() {
    cardNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset('assets/background.jpeg', fit: BoxFit.cover),
          ),
          // Foreground UI
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 60),
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Complete Your Payment',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Booking ID: ${widget.bookingId}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Amount to Pay: \$${widget.totalCost.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: paymentMethod,
                        onChanged: (val) => setState(() => paymentMethod = val!),
                        decoration: InputDecoration(
                          labelText: 'Payment Method',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        items: ['Card', 'Cash', 'Online'].map(
                          (mode) => DropdownMenuItem(
                            value: mode,
                            child: Text(mode),
                          ),
                        ).toList(),
                      ),
                      if (paymentMethod == 'Card') ...[
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 70,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: cardImages.entries.map((entry) {
                              final isSelected = cardType == entry.key;
                              return GestureDetector(
                                onTap: () => setState(() => cardType = entry.key),
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 8),
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: isSelected ? Colors.green : Colors.grey,
                                      width: isSelected ? 3 : 1,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    children: [
                                      Image.asset(
                                        entry.value,
                                        width: 50,
                                        height: 30,
                                      ),
                                      Text(
                                        entry.key,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: cardNumberController,
                          decoration: InputDecoration(
                            labelText: 'Card Number',
                            hintText: 'Enter 16-digit card number',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          keyboardType: TextInputType.number,
                          maxLength: 16,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter card number';
                            }
                            if (value.length != 16) {
                              return 'Card number must be 16 digits';
                            }
                            if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                              return 'Card number must be numeric';
                            }
                            return null;
                          },
                        ),
                      ],
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: submitPayment,
                        icon: const Icon(Icons.payment),
                        label: const Text('Pay Now'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[700],
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
