import 'package:flutter/material.dart';
import 'package:variant_dashboard/app/udaan_saarathi/features/presentation/profile/page/profile_cards_group.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned(
            // top right , rectangle , tall
            top: 26,
            right: 26,
            bottom: 16,
            child: Column(
              children: [
                Card(
                  child: SizedBox(
                    width: 360,
                    child: SingleChildScrollView(
                      child: ProfileCardsGroup(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // when one of the profile card is pressed 
            
        ],
      ),
    );
  }
}