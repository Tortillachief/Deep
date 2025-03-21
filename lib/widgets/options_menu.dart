import 'package:deep/constants.dart';
import 'package:deep/utils/color_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:deep/card_service.dart';
import 'package:deep/settings_provider.dart';
import 'package:deep/widgets/game_card.dart';

class OptionsMenu extends StatelessWidget {
  final VoidCallback onOptionsApplied;

  const OptionsMenu({
    super.key,
    required this.onOptionsApplied,
  });

  static const optionsSpacing = 10.0;

  @override
  Widget build(BuildContext context) {
    final cardService = context.read<CardService>();
    final settingsProvider = context.read<SettingsProvider>();
    final screenSize = MediaQuery.of(context).size;

    return StatefulBuilder(
      builder: (context, setModalState) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenSize.width * 0.04,
            vertical: 16,
          ),
          child: Column(
            spacing: optionsSpacing,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Card Options',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () {
                      Navigator.pop(context);
                      onOptionsApplied();
                    },
                  ),
                ],
              ),

              // Shuffle toggle
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: settingsProvider.shuffleEnabled
                      ? ColorUtils.withOpacity(Colors.deepPurple, 0.3)
                      : Colors.black26,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SwitchListTile(
                  title: Row(
                    children: [
                      Icon(
                        settingsProvider.shuffleEnabled
                            ? Icons.shuffle
                            : Icons.sort,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Shuffle Cards',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  subtitle: Text(
                    settingsProvider.shuffleEnabled
                        ? 'Cards will appear in random order'
                        : 'Cards will appear in sequence',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  value: settingsProvider.shuffleEnabled,
                  onChanged: (value) {
                    setModalState(() {
                      settingsProvider.toggleShuffle(value);
                      cardService.toggleShuffle(value);
                    });
                  },
                  activeColor: Colors.blueGrey,
                ),
              ),

              const Divider(color: Colors.white24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Card Types',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),

                  // Reset filters button
                  TextButton.icon(
                    onPressed: () {
                      setModalState(() {
                        settingsProvider.resetSettings();
                        // Update CardService with new settings
                        cardService.toggleCardTypeFilter(
                            GameCardType.icebreaker, true);
                        cardService.toggleCardTypeFilter(
                            GameCardType.confession, true);
                        cardService.toggleCardTypeFilter(
                            GameCardType.deep, true);
                        cardService.toggleShuffle(true);
                      });
                    },
                    icon: const Icon(Icons.refresh,
                        size: 16, color: Colors.white70),
                    label: const Text('Reset',
                        style: TextStyle(color: Colors.white70)),
                  ),
                ],
              ),


              // Card type selectors
              _buildCardTypeSelector(
                setModalState: setModalState,
                title: icebreakerText,
                subtitle: 'Casual conversation starters',
                color: icebreakerBackgroundColor,
                textColor: Colors.white,
                isActive: settingsProvider.showIcebreakers,
                onToggle: (value) {
                  cardService.toggleCardTypeFilter(
                      GameCardType.icebreaker, value);
                  settingsProvider.toggleCardType(
                      GameCardType.icebreaker, value);
                },
              ),


              _buildCardTypeSelector(
                setModalState: setModalState,
                title: confessionText,
                subtitle: 'Personal experiences and stories',
                color: confessionBackgroundColor,
                textColor: Colors.white,
                isActive: settingsProvider.showConfessions,
                onToggle: (value) {
                  cardService.toggleCardTypeFilter(
                      GameCardType.confession, value);
                  settingsProvider.toggleCardType(
                      GameCardType.confession, value);
                },
              ),


              _buildCardTypeSelector(
                setModalState: setModalState,
                title: deepText,
                subtitle: 'Thought-provoking questions',
                color: deepBackgroundColor,
                textColor: Colors.white,
                isActive: settingsProvider.showDeeps,
                onToggle: (value) {
                  cardService.toggleCardTypeFilter(GameCardType.deep, value);
                  settingsProvider.toggleCardType(GameCardType.deep, value);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper method to build stats tiles
  Widget _buildStatTile(
      {required String title, required String value, required IconData icon}) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 22),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: ColorUtils.withOpacity(Colors.white, 0.7),
          ),
        ),
      ],
    );
  }

  // Helper method to build card type selectors
  Widget _buildCardTypeSelector({
    required StateSetter setModalState,
    required String title,
    required String subtitle,
    required Color color,
    required Color textColor,
    required bool isActive,
    required Function(bool) onToggle,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: isActive
            ? ColorUtils.withOpacity(color, 0.4)
            : ColorUtils.withOpacity(Colors.deepPurpleAccent, 0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        title: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: ColorUtils.withOpacity(color, 1.0),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        value: isActive,
        onChanged: (value) {
          setModalState(() {
            onToggle(value);
          });
        },
        activeColor: color,
      ),
    );
  }
}

void showOptionsMenu(BuildContext context, VoidCallback onOptionsApplied) {
  showModalBottomSheet(
    context: context,
    backgroundColor: ColorUtils.withOpacity(const Color.fromARGB(255, 45, 45, 45), 1),
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    elevation: 20,
    constraints: BoxConstraints(
      maxHeight: MediaQuery.of(context).size.height * 0.9,
    ),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (context) => SingleChildScrollView(
      child: OptionsMenu(onOptionsApplied: onOptionsApplied),
    ),
  );
}
