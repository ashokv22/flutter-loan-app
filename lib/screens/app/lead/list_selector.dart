import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListSelector extends StatefulWidget {
  const ListSelector({super.key});

  @override
  State<ListSelector> createState() => _ListSelectorState();
}

class _ListSelectorState extends State<ListSelector> {
  List<Message> messages = List.generate(
    10,
    (index) => Message(
      id: index,
      text: 'Message $index',
    ),
  );
  List<String> countries = ["Brazil", "Nepal", "India", "China", "USA", "Canada"];

  List<int> selectedMessages = [];
  bool isSelectionMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isSelectionMode ? 'Select Messages' : 'Messages'),
        actions: isSelectionMode
            ? [
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedMessages.clear();
                      isSelectionMode = false;
                      _showDeleteConfirmationDialog(context);
                    });
                  },
                  child: const Text('Done'),
                ),
              ]
            : null
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                Color.fromRGBO(193, 248, 245, 1),
                Color.fromRGBO(184, 182, 253, 1),
                Color.fromRGBO(62, 58, 250, 1),
              ]
            ),
          ),
        child: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final message = messages[index];
          final isSelected = selectedMessages.contains(message.id);

          return LongPressSelectionItem(
            key: Key(message.id.toString()),
            message: message,
            isSelected: isSelected,
            isSelectionMode: isSelectionMode,
            onTap: () {
              setState(() {
                if (isSelectionMode) {
                    if (isSelected) {
                      selectedMessages.remove(message.id);
                    } else {
                      selectedMessages.add(message.id);
                    }
                } else {
                  // If not in selection mode, enter selection mode on tap
                  isSelectionMode = true;
                  selectedMessages.clear();
                  selectedMessages.add(message.id);
                }
              });
            },
            onLongPress: () {
              setState(() {
                if (!isSelectionMode) {
                   // Enter selection mode on long press
                  isSelectionMode = true;
                  selectedMessages.clear();
                  selectedMessages.add(message.id);
                }
              });
            },
          );
        },
      ),
      )
    );
  }

  Widget buildContainerWithChips() {
    return Container(
      width: 500,
      height: 100,
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      padding: const EdgeInsets.all(0.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), //color of shadow
            spreadRadius: 2, //spread radius
            blurRadius: 6, // blur radius
            offset: const Offset(2, 3),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(2.0),
            children: countries.map((country){
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Chip(
                  avatar: Icon(Icons.science_rounded),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                  label: Text(country),
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'Are you sure you want to delete?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                            child: Text('Cancel', style: TextStyle(color: Colors.black),),
                          ),
                        ),
                        const SizedBox(width: 10,),
                        Expanded(
                          child: MaterialButton(
                            onPressed: () {
                              // submitLoanApplication();
                              // Navigator.of(context).pop();
                            },
                            color: const Color.fromARGB(255, 6, 139, 26),
                            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: const Text('Submit', style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        );
      },
    );
  }
}

class LongPressSelectionItem extends StatefulWidget {
  final Message message;
  final bool isSelected;
  final bool isSelectionMode;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const LongPressSelectionItem({
    required Key key,
    required this.message,
    required this.isSelected,
    required this.isSelectionMode,
    required this.onTap,
    required this.onLongPress,
  }) : super(key: key);

  @override
  State<LongPressSelectionItem> createState() => _LongPressSelectionItemState();
}

class _LongPressSelectionItemState extends State<LongPressSelectionItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        child: Row(
          children: [
            if (widget.isSelectionMode)
              Radio(
                value: widget.isSelected,
                groupValue: true,
                onChanged: (value) {},
              ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset('assets/images/female-01.jpg', fit: BoxFit.cover,)),
                  ),
                  const SizedBox(width: 10,),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Ashok"),
                      Text("Hi, how are you?"),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Message {
  int id;
  String text;

  Message({required this.id, required this.text});
}