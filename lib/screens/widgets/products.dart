import 'package:flutter/material.dart';
import 'package:origination/screens/app/lead/new_lead.dart';

class Products extends StatefulWidget {
  const Products({super.key});

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  String selectedOption = 'Tractor Loan';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.32,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppBar(
            automaticallyImplyLeading: false,
            title: const Text('Product'),
            actions: [
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
          Container(
            color: Colors.white,
            child: Expanded(
              child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        buildRadioButton('Tractor Loan'),
                        buildRadioButton('KCC Loan'),
                        buildRadioButton('Dealer TA')
                      ],
                    ),
                  ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 80.0,
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NewLead(),
                  ),
                );
            },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 3, 71, 244),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.0),
                ),
              ),
              child: const Text('Continue', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildRadioButton(String label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18.0),
        ),
        Radio(
          value: label,
          groupValue: selectedOption,
          onChanged: (value) {
            setState(() {
              selectedOption = value!;
            });
          },
        ),
      ],
    );
  }

}
