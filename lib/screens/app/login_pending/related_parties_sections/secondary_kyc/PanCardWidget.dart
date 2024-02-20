import 'package:flutter/material.dart';
import 'package:origination/models/login_flow/sections/related_party/pan_request_dto.dart';

class PanCardWidget extends StatelessWidget {
  const PanCardWidget({
    super.key,
    required this.panData,
    required this.isLoading,
  });

  final PanRequestDTO panData;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          // height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            // color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.white.withAlpha(100),
                blurRadius: 10.0,
                spreadRadius: 0.0,
              ),
            ],
            color: Colors.white.withOpacity(0.4),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  "Pan Details",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Lucida Sans',
                      fontSize: 20),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Name:",
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
                    ),
                    const SizedBox(width: 5),
                    Text('${panData.firstname} ${panData.lastname}',
                        style: const TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 18)),
                  ],
                ),
                const SizedBox(height: 10),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Father Name:",
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
                    ),
                    SizedBox(width: 5),
                    Text("NA",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 18)),
                  ],
                ),
                const SizedBox(height: 10),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Date of Birth:",
                      style:
                          TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
                    ),
                    SizedBox(width: 5),
                    Text("NA",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 18)),
                  ],
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: MaterialButton(
                      onPressed: () {
                        // save();
                      },
                      color: const Color.fromARGB(255, 3, 71, 244),
                      textColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              width: 20.0,
                              height: 20.0,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Save'),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
