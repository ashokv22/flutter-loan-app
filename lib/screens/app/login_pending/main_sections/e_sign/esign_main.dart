import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:origination/screens/app/login_pending/main_sections/e_sign/esign_rp_list.dart';

class ESignMain extends StatefulWidget {
  const ESignMain({
    super.key,
    required this.applicantId,
  });

  final int applicantId;

  @override
  State<ESignMain> createState() => _ESignMainState();
}

class _ESignMainState extends State<ESignMain> {
  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(CupertinoIcons.arrow_left)),
        title: const Text("Initiate E-Sign Loan Documents", style: TextStyle(fontSize: 16)),
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
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ESignRpList(applicantId: widget.applicantId)));
                },
                child: Container(
                  margin:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          width: 0.50,
                          strokeAlign: BorderSide.strokeAlignOutside,
                          color: isDarkTheme ? Colors.white70 : Colors.black87),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const HeroIcon(HeroIcons.documentText, size: 22),
                          const SizedBox(width: 10),
                          Text(
                            "Initiate E-Sign\nPre-Sanction Documents",
                            style: TextStyle(
                              color: Theme.of(context).textTheme.displayMedium!.color,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        CupertinoIcons.chevron_right_circle,
                        color: Theme.of(context).iconTheme.color,
                        size: 22,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ESignRpList(applicantId: widget.applicantId)));
                },
                child: Container(
                  margin:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          width: 0.50,
                          strokeAlign: BorderSide.strokeAlignOutside,
                          color: isDarkTheme ? Colors.white70 : Colors.black87),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const HeroIcon(HeroIcons.documentText, size: 22),
                          const SizedBox(width: 10),
                          Text(
                            "Initiate E-Sign\nPost-Sanction Documents",
                            style: TextStyle(
                              color: Theme.of(context).textTheme.displayMedium!.color,
                              fontSize: 16,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        CupertinoIcons.chevron_right_circle,
                        color: Theme.of(context).iconTheme.color,
                        size: 22,
                      )
                    ],
                  ),
                ),
              )
            ],
          )
      ),
    );
  }
}
