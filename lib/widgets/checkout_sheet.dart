import 'package:flutter/material.dart';
import '../core/event_model.dart';

class CheckoutSheet extends StatefulWidget {
  final NightlifeEvent event;
  const CheckoutSheet({super.key, required this.event});

  @override
  State<CheckoutSheet> createState() => _CheckoutSheetState();
}

class _CheckoutSheetState extends State<CheckoutSheet> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    // Parse price string to number for calculation (removes commas)
    int pricePerTicket =
        int.tryParse(widget.event.price.replaceAll(',', '')) ?? 0;
    int total = pricePerTicket * quantity;

    return Container(
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A1A),
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.event.title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Text(
            widget.event.venue,
            style: TextStyle(color: Colors.white.withOpacity(0.6)),
          ),
          const Divider(height: 30, color: Colors.white10),

          // Quantity Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Number of Tickets", style: TextStyle(fontSize: 16)),
              Row(
                children: [
                  IconButton(
                    onPressed: () =>
                        setState(() => quantity > 1 ? quantity-- : null),
                    icon: const Icon(
                      Icons.remove_circle_outline,
                      color: Color(0xFF00FFA3),
                    ),
                  ),
                  Text(
                    "$quantity",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() => quantity++),
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: Color(0xFF00FFA3),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Total and Pay Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              Text(
                "TZS ${total.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF00FFA3),
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          SThemeButton(
            text: "PAY WITH MOBILE MONEY",
            onPressed: () {
              Navigator.pop(context);
              // Future: Trigger M-Pesa/Tigo Pesa STK Push
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

// Helper widget for the consistent Neon Button
class SThemeButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const SThemeButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF00FFA3),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
