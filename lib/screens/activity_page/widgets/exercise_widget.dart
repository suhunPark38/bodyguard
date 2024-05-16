import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';


class ExerciseWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return  Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child:  Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "운동 기록",
                        style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 15),
                      ),
                      Icon(Icons.sports_baseball,)
                    ]),
                const SizedBox(height: 10),
                GridView(
                  shrinkWrap: true,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  children: [
                    Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Icon(Icons.directions_run))),

                    Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Icon(Icons.stairs))),

                    Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.all(16),
                            child:  Icon(Icons.pool),)),

                    Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Icon(Icons.list))),
                  ],
                )
              ],
            )


        )
    );
  }
}

