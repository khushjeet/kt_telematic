import 'package:flutter/material.dart';
import 'package:ktr/models/user_model_one.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({super.key, required this.places});
  final List<User> places;

  @override
  Widget build(
    BuildContext context,
  ) {
    Widget content = const Center(
      child: Text("No User Added Yet....."),
    );
    if (places.isNotEmpty) {
      content = ListView.builder(
          itemCount: places.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(200),
                      ),
                      color: Colors.amber,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                              trailing: Column(
                                children: [
                                  Text(places[index]
                                      .placeLocation
                                      .latitude
                                      .toDouble()
                                      .toString()),
                                  Text(places[index]
                                      .placeLocation
                                      .longitude
                                      .toDouble()
                                      .toString()),
                                ],
                              ),
                              title: Column(
                                children: [
                                  Text(places[index].userName),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(places[index].title),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(places[index].userEmail),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        places[index].placeLocation.address,
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    ],
                                  )
                                ],
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          });
    }

    return content;
  }
}
