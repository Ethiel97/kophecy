import 'package:flutter/material.dart';
import 'package:kophecy/models/tag.dart';
import 'package:kophecy/utils/text_styles.dart';
import 'package:kophecy/view_models/quote_view_model.dart';
import 'package:tinycolor2/tinycolor2.dart';

class WTag extends StatelessWidget {
  const WTag({
    Key? key,
    required this.tag,
    required this.quoteViewModel,
  }) : super(key: key);

  final Tag tag;
  final QuoteViewModel quoteViewModel;

  @override
  Widget build(BuildContext context) => _buildTag(context, quoteViewModel);

  bool get isSelected => quoteViewModel.selectedTags.contains(tag);

  Widget _buildTag(BuildContext context, QuoteViewModel quoteViewModel) =>
      GestureDetector(
        onTap: () => quoteViewModel.selectTag(tag),
        child: Container(
          padding: const EdgeInsets.all(9),
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isSelected
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).backgroundColor.lighten().withOpacity(.8),
          ),
          child: Text(
            "#${tag.name}",
            style: TextStyles.textStyle.apply(
              fontSizeDelta: -7,
              fontWeightDelta: 5,
              color: isSelected
                  ? Colors.white
                  : Theme.of(context).textTheme.bodyText1?.color,
            ),
          ),
        ),
      );
}
