import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InformationScreen extends StatefulWidget {
  const InformationScreen({super.key});

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(CupertinoIcons.arrow_left)),
          title: const Text("Build Info",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        body: ListView(
          padding: const EdgeInsets.all(12.0),
          children: const [
            BuildInfoTile(
              icon: Icons.developer_mode,
              serverName: 'Dev-FT7',
              lastReleasedDate: '2024-05-31',
              currentVersion: '0.0.42',
            ),
            BuildInfoTile(
              icon: Icons.developer_mode,
              serverName: 'Dev-FT16',
              lastReleasedDate: '2024-06-20',
              currentVersion: '0.0.862',
            ),
            BuildInfoTile(
              icon: Icons.stacked_bar_chart,
              serverName: 'Staging',
              lastReleasedDate: '2024-05-07',
              currentVersion: '0.0.652',
            ),
            BuildInfoTile(
              icon: Icons.public,
              serverName: 'Prod - Coming soon',
              lastReleasedDate: '',
              currentVersion: '',
            ),
          ],
        )
    );
  }
}

class BuildInfoTile extends StatelessWidget {
  final IconData icon;
  final String serverName;
  final String lastReleasedDate;
  final String currentVersion;

  const BuildInfoTile({super.key, 
    required this.icon,
    required this.serverName,
    required this.lastReleasedDate,
    required this.currentVersion,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.blue.withOpacity(0.1),
            ),
            child: Icon(icon, color: Colors.blue),
          ),
          const SizedBox(width: 12.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                serverName,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              // SizedBox(height: 8.0),
              Text(
                'Last Released Date: $lastReleasedDate',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              // SizedBox(height: 4.0),
              Text(
                'Current Version: $currentVersion',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
