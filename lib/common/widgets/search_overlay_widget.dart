import 'package:flutter/material.dart';
import 'package:flutter_restaurant/features/search/widget/search_recommended_widget.dart';
import 'package:flutter_restaurant/features/search/widget/search_suggestion_widget.dart';
import 'package:flutter_restaurant/features/search/providers/search_provider.dart';
import 'package:flutter_restaurant/utill/dimensions.dart';
import 'package:provider/provider.dart';

class SearchOverlayWidget extends StatelessWidget {
  final String searchText;
  final VoidCallback onClose;

  const SearchOverlayWidget({
    super.key,
    required this.searchText,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {}, // Prevents taps from passing through to background
      child: Container(
        width: 400,
        constraints: const BoxConstraints(maxHeight: 400),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          child: Consumer<SearchProvider>(
            builder: (context, searchProvider, _) {
              return Listener(
                onPointerDown: (event) {
                  // Close overlay after a small delay to allow the tap to register
                  Future.delayed(const Duration(milliseconds: 300), () {
                    onClose();
                  });
                },
                child: searchText.isEmpty
                    ? const SearchRecommendedWidget()
                    : SearchSuggestionWidget(searchedText: searchText),
              );
            },
          ),
        ),
      ),
    );
  }
}
