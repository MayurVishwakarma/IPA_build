import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Shimmer.fromColors(
          baseColor: const Color.fromARGB(255, 219, 219, 219),
          highlightColor: const Color.fromARGB(255, 241, 241, 241),
          child: Column(
            children: [
              Container(
                height: 100,
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                width: MediaQuery.of(context).size.width,
              ),
              Container(
                height: 50,
                padding: const EdgeInsets.all(5),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                width: MediaQuery.of(context).size.width,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      // width: MediaQuery.of(context).size.width/2,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      // width: MediaQuery.of(context).size.width/2,
                    ),
                  ),
                ],
              ),
              const ShimmerRow(),
              const ShimmerRow(),
              const ShimmerRow(),
              const ShimmerRow(),
              const ShimmerRow(),
              const ShimmerRow(),
            ],
          ),
        )
      ],
    );
  }
}

class ShimmerRow extends StatelessWidget {
  const ShimmerRow({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: Container(
            height: 40,
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white),
            // width: MediaQuery.of(context).size.width/2,
          ),
        ),
        Expanded(
          flex: 2,
          child: Container(
            height: 40,
            padding: const EdgeInsets.all(5),
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.white),
            // width: MediaQuery.of(context).size.width/2,
          ),
        ),
      ],
    );
  }
}
