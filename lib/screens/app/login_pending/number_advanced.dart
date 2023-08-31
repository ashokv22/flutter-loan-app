import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NumberInputSheet extends StatefulWidget {
  const NumberInputSheet({
    super.key,
  });

  @override
  State<NumberInputSheet> createState() => _NumberInputSheetState();
}

class _NumberInputSheetState extends State<NumberInputSheet> {
  final TextEditingController _controller = TextEditingController();
  double _amount = 0.0;
  int _selectedAmountIndex = -1;

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () {Navigator.pop(context);}, icon: const Icon(CupertinoIcons.arrow_left)),
        title: const Text("Details"),
      ),
      body: Container(
        decoration: BoxDecoration(
          border: isDarkTheme
          ? Border.all(color: Colors.white12, width: 1.0) // Outlined border for dark theme
          : null,
            gradient: isDarkTheme
              ? null // No gradient for dark theme, use a single color
              : const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Color.fromRGBO(193, 248, 245, 1),
                Color.fromRGBO(184, 182, 253, 1),
                Color.fromRGBO(62, 58, 250, 1),
              ]
            ),
            color: isDarkTheme ? Colors.black38 : null
          ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _controller,
                    keyboardType: const TextInputType.numberWithOptions(decimal: false),
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.edit),
                        // onPressed: () => _showAmountPicker(context),
                        onPressed: () {
                          Future.delayed(Duration.zero, () {
                            _showAmountPicker(context);
                          });
                        }
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAmountPicker(BuildContext context) {
    final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '\u20B9');
    final formattedAmount = formatter.format(_amount);
    _controller.text = formattedAmount.replaceAll(',', '');
    
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        _controller.text = _amount.toStringAsFixed(0);
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: Padding(
              padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.currency_rupee, size: 20),
                      const SizedBox(width: 5),
                      SizedBox(
                        width: 200,
                        child: TextFormField(
                          controller: _controller,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              _amount = double.tryParse(value.replaceAll(',', '')) ?? 0.0;
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: 'Enter amount',
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          // inputFormatters: [CurrencyTextInputFormatter()],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Column(
                          children: [
                            _buildAmountButton(0, 100000),
                          ],
                        ),
                        Column(
                          children: [
                            _buildAmountButton(1, 200000),
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '🌟Popular',
                                style: TextStyle(color: Colors.orange),
                              ),
                            )
                          ],
                        ),
                        Column(
                          children: [
                            _buildAmountButton(2, 500000),
                          ],
                        ),
                        Column(
                          children: [
                            _buildAmountButton(3, 800000),
                          ],
                        ),
                        Column(
                          children: [
                            _buildAmountButton(4, 1000000),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 45, 196, 77),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _controller.text = _amount.toStringAsFixed(2);
                      },
                      child: const Text('Done', style: TextStyle(color: Colors.white)),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAmountButton(int index, double amount) {
    final isSelected = _selectedAmountIndex == index;

    return OutlinedButton(
      onPressed: () {
        setState(() {
          _selectedAmountIndex = isSelected ? -1 : index; // Toggle selection
          _amount = isSelected ? 0.0 : amount; // If already selected, reset the amount
        });
      },
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          width: 2.0,
          color: isSelected ? Colors.blue : Colors.grey, // Change color based on selection
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Text('\u20B9$amount'),
    );
  }


}