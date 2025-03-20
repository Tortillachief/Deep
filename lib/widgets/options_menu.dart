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

  @override
  Widget build(BuildContext context) {
    final cardService = context.read<CardService>();
    final settingsProvider = context.read<SettingsProvider>();

    return StatefulBuilder(
      builder: (context, setModalState) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
          child: Column(
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
                      fontSize: 24, 
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Stats section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatTile(
                      title: 'Total Cards', 
                      value: cardService.cards.length.toString(),
                      icon: Icons.library_books,
                    ),
                    _buildStatTile(
                      title: 'Active Cards', 
                      value: cardService.filteredCards.length.toString(),
                      icon: Icons.check_circle_outline,
                    ),
                    _buildStatTile(
                      title: 'Filters Active', 
                      value: (!settingsProvider.showIcebreakers || 
                             !settingsProvider.showConfessions || 
                             !settingsProvider.showDeeps) ? 'Yes' : 'No',
                      icon: Icons.filter_list,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              
              // Shuffle toggle
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: settingsProvider.shuffleEnabled 
                      ? Colors.deepPurple.withOpacity(0.3) 
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
                  activeColor: Colors.deepPurple,
                ),
              ),
              
              const SizedBox(height: 20),
              const Divider(color: Colors.white24),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Card Types',
                    style: TextStyle(
                      fontSize: 18,
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
                        cardService.toggleCardTypeFilter(GameCardType.icebreaker, true);
                        cardService.toggleCardTypeFilter(GameCardType.confession, true);
                        cardService.toggleCardTypeFilter(GameCardType.deep, true);
                        cardService.toggleShuffle(true);
                      });
                    },
                    icon: const Icon(Icons.refresh, size: 16, color: Colors.white70),
                    label: const Text('Reset', style: TextStyle(color: Colors.white70)),
                  ),
                ],
              ),
              
              const SizedBox(height: 10),
              
              // Card type selectors
              _buildCardTypeSelector(
                setModalState: setModalState,
                title: 'Icebreakers',
                subtitle: 'Casual conversation starters',
                color: Colors.blue,
                isActive: settingsProvider.showIcebreakers,
                onToggle: (value) {
                  cardService.toggleCardTypeFilter(GameCardType.icebreaker, value);
                  settingsProvider.toggleCardType(GameCardType.icebreaker, value);
                },
              ),
              
              const SizedBox(height: 10),
              
              _buildCardTypeSelector(
                setModalState: setModalState,
                title: 'Confessions',
                subtitle: 'Personal experiences and stories',
                color: Colors.amber.shade700,
                isActive: settingsProvider.showConfessions,
                onToggle: (value) {
                  cardService.toggleCardTypeFilter(GameCardType.confession, value);
                  settingsProvider.toggleCardType(GameCardType.confession, value);
                },
              ),
              
              const SizedBox(height: 10),
              
              _buildCardTypeSelector(
                setModalState: setModalState,
                title: 'Deep',
                subtitle: 'Thought-provoking questions',
                color: Colors.deepPurple,
                isActive: settingsProvider.showDeeps,
                onToggle: (value) {
                  cardService.toggleCardTypeFilter(GameCardType.deep, value);
                  settingsProvider.toggleCardType(GameCardType.deep, value);
                },
              ),
              
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onOptionsApplied(); // Get next card with new filters
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    elevation: 5,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check),
                      SizedBox(width: 8),
                      Text('Apply Filters', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  
  // Helper method to build stats tiles
  Widget _buildStatTile({required String title, required String value, required IconData icon}) {
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
            color: Colors.white.withOpacity(0.7),
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
    required bool isActive,
    required Function(bool) onToggle,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: isActive ? color.withOpacity(0.3) : Colors.black26,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SwitchListTile(
        title: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(color: Colors.white70),
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
    backgroundColor: Colors.grey.shade800,
    isScrollControlled: true,
    elevation: 20,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20))
    ),
    builder: (context) => OptionsMenu(onOptionsApplied: onOptionsApplied),
  );
}