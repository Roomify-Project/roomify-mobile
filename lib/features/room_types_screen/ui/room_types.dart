import 'package:flutter/material.dart';

class RoomTypeScreen extends StatelessWidget {
  const RoomTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 0),
      child: Container(
        width: 402,
        height: 679,
        decoration: BoxDecoration(
          color: const Color(0xFF27012f),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Choose room type',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 35),
              Expanded(
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 19,
                  childAspectRatio: 185 / 145,
                  children: [
                    _buildNullCard(),
                    _buildRoomCard('bedroom', 'assets/images/download 15.png'),
                    _buildRoomCard(
                        'living room', 'assets/images/download 16.png'),
                    _buildRoomCard('kitchen', 'assets/images/download 17.png'),
                    _buildRoomCard('office', 'assets/images/download 18.png'),
                    _buildRoomCard('bathroom', 'assets/images/download 19.png'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 29),
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNullCard() {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              border: Border.all(color: Colors.purple, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Icon(
                Icons.block,
                size: 40,
                color: Colors.purple,
              ),
            ),
          ),
        ),
        const SizedBox(height: 2),
        const Text(
          'Null',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildRoomCard(String title, String imagePath) {
    return Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ],
    );
  }
}
