import 'package:flutter/material.dart';
import 'package:kolor_klash/theme/app_colors.dart';

class TileContainer extends StatelessWidget {
  final int tileNumber;

  const TileContainer({
    super.key,
    required this.tileNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.whiteOpacity(0.2),
          width: 1,
        ),
        color: AppColors.whiteOpacity(0.08),
      ),
      child: Row(
        children: [
          // Column 1
          Expanded(
            child: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border(
                  right: BorderSide(
                    color: AppColors.whiteOpacity(0.2),
                    width: 0.5,
                  ),
                ),
              ),
            ),
          ),
          // Column 2
          Expanded(
            child: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border(
                  right: BorderSide(
                    color: AppColors.whiteOpacity(0.2),
                    width: 0.5,
                  ),
                ),
              ),
            ),
          ),
          // Column 3
          Expanded(
            child: Container(
              height: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}