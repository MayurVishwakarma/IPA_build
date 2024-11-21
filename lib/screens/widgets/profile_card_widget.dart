import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timesheet/provider/data_provider.dart';

class ProfileCardWidget extends StatelessWidget {
  ProfileCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final dtProvider = Provider.of<DataProvider>(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(1000),
                child: Image.asset(
                  dtProvider.gender == 'female'
                      ? "assets/images/woman.png"
                      : "assets/images/man.png",
                  height: 70,
                  width: 70,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dtProvider.userName.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(dtProvider.gender.toString().toUpperCase()),
                  const Text("Jr. Software Dev"),
                ],
              )
            ],
          ),
          const Divider(
            thickness: 0.5,
            color: Colors.grey,
          ),
          profileListTile("Employee Id", dtProvider.userId.toString()),
          // profileListTile("Joined Date", "07-Mar-2022"),
        ],
      ),
    );
  }

  Widget profileListTile(text, value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text),
          Text(
            value,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
