import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class FirstGame extends StatefulWidget {
  @override
  _FirstGameState createState() => _FirstGameState();
}

class _FirstGameState extends State<FirstGame> {
  final List<String> initialImages = [
    'Assets/images/yellow.png',
    'Assets/images/green.png',
    'Assets/images/blue.png',
    'Assets/images/orange.png',
    'Assets/images/red.png'
  ];

  List<String> tileImages = [];
  List<String> originalTileImages = [];

  final String klmLogo = 'Assets/images/wall.png';
  List<int> selectedIndexes = [];
  bool isTileClickable = true;

  final List<int> tilesPerRow = [4, 4, 2]; // Number of tiles in each row
  final Duration gameDuration =
      Duration(seconds: 60); // 60 seconds game duration
  late Stream<int> timerStream; // Timer stream for game duration

  @override
  void initState() {
    super.initState();
    initializeTiles();
    Timer(Duration(seconds: 5), () {
      setState(() {
        tileImages = List.filled(originalTileImages.length, klmLogo);
      });
    });
    startGameTimer();
  }

  void initializeTiles() {
    List<String> doubledImages = List.from(initialImages)
      ..addAll(initialImages);
    doubledImages.shuffle(Random());
    originalTileImages = doubledImages;

    setState(() {
      tileImages = List.filled(originalTileImages.length, klmLogo);
    });
  }

  void startGameTimer() {
    timerStream = Stream<int>.periodic(Duration(seconds: 1), (count) => count)
        .take(gameDuration.inSeconds + 1);

    timerStream.listen((elapsedSeconds) {
      if (elapsedSeconds == gameDuration.inSeconds) {
        // Game over logic, handle what happens when time runs out
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Time\'s Up!'),
              content: Text('Game Over!'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    // Reset the game or navigate to another screen
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    });
  }

  void flipTile(int tileIndex) {
    if (!isTileClickable || selectedIndexes.length >= 2) return;

    setState(() {
      if (tileImages[tileIndex] == klmLogo) {
        tileImages[tileIndex] = originalTileImages[tileIndex];
        selectedIndexes.add(tileIndex);
      }
    });

    if (selectedIndexes.length == 2) {
      isTileClickable = false; // Disable clicking during comparison
      Future.delayed(Duration(seconds: 1), () {
        if (originalTileImages[selectedIndexes[0]] !=
            originalTileImages[selectedIndexes[1]]) {
          setState(() {
            tileImages[selectedIndexes[0]] = klmLogo;
            tileImages[selectedIndexes[1]] = klmLogo;
          });
        }
        selectedIndexes.clear();
        isTileClickable = true; // Enable clicking again
      });
    }
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    int currentIndex = 0;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('Assets/images/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            // Your other UI elements
            // ...

            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: tilesPerRow.map((numberOfTilesInRow) {
                    List<Widget> rowChildren =
                        List.generate(numberOfTilesInRow, (index) {
                      int tileIndex = currentIndex++;
                      return GestureDetector(
                        onTap: () => flipTile(tileIndex),
                        child: Image.asset(
                          tileImages[tileIndex],
                          width: 70,
                          height: 70,
                        ),
                      );
                    }).toList();

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: rowChildren,
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LevelTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Level Two'),
      ),
      body: Center(
        child: Text('Congratulations! You completed Level One.'),
      ),
    );
  }
}

class SettingsDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFB2E3F8), Color(0xFF54BCE3)],
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Settings',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: const Color.fromARGB(255, 0, 0, 0))),
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    color: Colors.black, // Black background for the container
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 11,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10), // Spacing between the title and the content
            _buildSettingRow(context, Icons.volume_up),
            _buildSettingRow(context, Icons.wifi),
            _buildIconRow(context), // Row with two icons beside each other
// Add more icons or containers if necessary
          ],
        ),
      ),
    );
  }

  Widget _buildSettingRow(BuildContext context, IconData iconData) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildSettingIcon(context, iconData),
          _buildToggleSwitch(context),
        ],
      ),
    );
  }

  Widget _buildSettingIcon(BuildContext context, IconData iconData) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xFFD6EFFF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Icon(iconData, color: Color(0xFF54BCE3)),
      ),
    );
  }

  Widget _buildToggleSwitch(BuildContext context) {
    return Switch(
      value:
          true, // This should be bound to some stateful logic to track on/off status.
      onChanged: (bool value) {
// Handle toggle switch change.
      },
      activeColor: Color(0xFF54BCE3),
    );
  }

  Widget _buildIconRow(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCenteredIcon(context, Icons.book),
            SizedBox(
              width: 22,
            ),
            _buildCenteredIcon(context, Icons.extension),
          ],
        ),
      ],
    );
  }

  Widget _buildCenteredIcon(BuildContext context, IconData iconData) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFD6EFFF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(iconData, color: Color(0xFF54BCE3)),
    );
  }
}
