import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Example imports, replace with your actual imports
import '/widgets/hud.dart';
import '/game/dino_run.dart';
import '/game/audio_manager.dart';
import '/models/player_data.dart';

// This represents the avatar selection overlay.
class Avatar extends StatelessWidget {
  // An unique identifier for this overlay.
  static const id = 'Avatar';

  // Reference to parent game.
  final DinoRun game;

  const Avatar(this.game, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: game.playerData,
      child: Center(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: Colors.black.withAlpha(100),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Selector<PlayerData, int>(
                        selector: (_, playerData) => playerData.currentScore,
                        builder: (_, score, __) {
                          return Text(
                            'Choose: Avatar',
                            style: const TextStyle(fontSize: 40, color: Colors.white),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      children: [
                        AvatarSelectionItem(
                          imagePath: 'assets/images/DinoSprites - tard.png',
                          isSelected: game.playerData.selectedAvatar == 'DinoSprites - tard.png',
                          onTap: () {
                            game.playerData.selectAvatar('DinoSprites - tard.png');
                          },
                        ),
                        AvatarSelectionItem(
                          imagePath: 'assets/images/AngryPig/Walk.png',
                          isSelected: game.playerData.selectedAvatar == '',
                          onTap: () {
                            game.playerData.selectAvatar('AngryPig/Walk.png');
                          },
                        ),
                        AvatarSelectionItem(
                          imagePath: 'assets/images/Bat/Flying.png',
                          isSelected: game.playerData.selectedAvatar == '',
                          onTap: () {
                            game.playerData.selectAvatar('Bat/Flying.png');
                          },
                        ),
                        AvatarSelectionItem(
                          imagePath: 'assets/images/Rino/Run.png',
                          isSelected: game.playerData.selectedAvatar == 'Rino/Ru.png',
                          onTap: () {
                            game.playerData.selectAvatar('Rino/Run.png');
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        game.startGamePlay();
                        game.overlays.remove(Avatar.id);
                        game.overlays.add(Hud.id);
                      },
                      child: const Text(
                        'Confirm',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Widget for selectable avatar item
class AvatarSelectionItem extends StatefulWidget {
  final String imagePath;
  final bool isSelected;
  final VoidCallback onTap;

  const AvatarSelectionItem({
    required this.imagePath,
    required this.isSelected,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  _AvatarSelectionItemState createState() => _AvatarSelectionItemState();
}

class _AvatarSelectionItemState extends State<AvatarSelectionItem> {
  bool _isSelected = false;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isSelected = !_isSelected; // Toggle the selected state
        });
        widget.onTap(); // Trigger the provided onTap callback
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: _isSelected ? Colors.blue : Colors.transparent, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: ClipRect(
                child: Align(
                  alignment: Alignment.center,
                  widthFactor: 1.0,
                  heightFactor: 1.0,
                  child: Image.asset(
                    widget.imagePath,
                    fit: BoxFit.cover, // Adjust the fit based on your requirement
                    width: 150, // Fixed width
                    height: 150, // Fixed height
                  ),
                ),
              ),
            ),
          ),
          if (_isSelected)
            Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10),
                ),
              ),
              child: Text(
                'Selected',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
