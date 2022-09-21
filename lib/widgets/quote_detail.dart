import 'package:flutter/material.dart';
import 'package:kophecy/models/quote.dart';
import 'package:kophecy/utils/constants.dart';
import 'package:kophecy/view_models/quote_view_model.dart';
import 'package:kophecy/widgets/quote_ui.dart';

class QuoteDetail extends StatefulWidget with QuoteUI {
  QuoteDetail({
    Key? key,
    required this.viewModel,
    this.userCanTranslate = true,
  }) : super(key: key);

  @override
  final QuoteViewModel viewModel;

  bool userCanTranslate;

  @override
  State<QuoteDetail> createState() => _QuoteDetailState();

  @override
  Quote get quote => viewModel.selectedQuote;

  @override
  bool get canViewDetail => false;

  @override
  bool get canTranslate => userCanTranslate;
}

class _QuoteDetailState extends State<QuoteDetail> {
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
  Widget build(BuildContext context) => widget.widgetToRender;
}
