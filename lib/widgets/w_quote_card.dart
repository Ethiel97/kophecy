import 'package:flutter/material.dart';
import 'package:kophecy/models/quote.dart';
import 'package:kophecy/utils/constants.dart';
import 'package:kophecy/view_models/quote_view_model.dart';
import 'package:kophecy/widgets/quote_ui.dart';

class WQuoteCard extends StatefulWidget with QuoteUI {
  WQuoteCard({
    required Key key,
    required this.quote,
    required this.onTranslate,
    required this.viewModel,
  }) : super(key: key);

  @override
  final Quote quote;

  @override
  final QuoteViewModel viewModel;

  final VoidCallback onTranslate;

  @override
  State<WQuoteCard> createState() => _WQuoteCardState();
}

class _WQuoteCardState extends State<WQuoteCard> {
  @override
  void initState() {
    super.initState();

    widget.initWidgetState(eventListener);
  }

  void eventListener(ev, cont) async {
    if (null != ev) {
      switch (ev.eventName) {
        case Constants.shareQuoteEvent:
          if (mounted) {
            // print("SHARING: ${widget.viewModel.selectedQuote.content}");
            setState(() {
              widget.canInteract = false;
            });

            await widget.viewModel.shareQuote();

            if (mounted) {
              setState(() {
                widget.canInteract = true;
              });
            }
          }

          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        child: widget.widgetToRender,
        onTap: () => widget.viewModel.selectQuote(widget.quote),
      );
}
