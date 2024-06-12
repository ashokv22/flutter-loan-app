import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:origination/screens/app/login_pending/main_sections/post_sanction/beneficiary_details.dart';

class PostSanctionMainList extends StatefulWidget {
  const PostSanctionMainList({
    super.key,
    required this.applicantId,
  });

  final int applicantId;

  @override
  State<PostSanctionMainList> createState() => _PostSanctionMainListState();
}

class _PostSanctionMainListState extends State<PostSanctionMainList> {
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
        title: const Text("Post Sanction", style: TextStyle(fontSize: 16)),
      ),
      body: Container(
        decoration: BoxDecoration(
            gradient: isDarkTheme
                ? null
                : const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                        Colors.white,
                        Color.fromRGBO(193, 248, 245, 1),
                        Color.fromRGBO(184, 182, 253, 1),
                        Color.fromRGBO(62, 58, 250, 1),
                      ]),
            color: isDarkTheme ? Colors.black38 : null),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BeneficiaryDetails(applicantId: widget.applicantId)));
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
                    Text(
                      "Add Beneficiary Details",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.displayMedium!.color,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
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
                // Navigator.push(context, MaterialPageRoute(builder: (context) => RelatedParties(id: widget.id,)));
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
                    Text(
                      "Add Security Cheques",
                      style: TextStyle(
                        color: Theme.of(context).textTheme.displayMedium!.color,
                        fontSize: 16,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                      ),
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
        ),
      ),
    );
  }
}
