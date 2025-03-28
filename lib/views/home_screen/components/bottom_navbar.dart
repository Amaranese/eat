import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: const BoxDecoration(
        color: Color(0xFFE6F7EF), // Light green background
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(3, (index) {
          final isSelected = currentIndex == index;
          return GestureDetector(
            onTap: () => onTabSelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isSelected ? 90 : 60,
              height: isSelected ? 70 : 50,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color.fromRGBO(76, 175, 80, 1)
                    : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    index == 0
                        ? Icons.home
                        : index == 1
                            ? Icons.menu_book
                            : Icons.bar_chart,
                    color: isSelected ? Colors.white : Colors.green,
                    size: isSelected ? 30 : 24,
                  ),
                  if (isSelected)
                    Text(
                      index == 0
                          ? 'Home'
                          : index == 1
                              ? 'Diary'
                              : 'Reports',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
