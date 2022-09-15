import 'package:flutter/material.dart';
import 'package:kophecy/models/quote.dart';
import 'package:kophecy/view_models/quote_view_model.dart';
import 'package:kophecy/widgets/quote_ui.dart';

class QuoteDetail extends StatelessWidget with QuoteUI {
  QuoteDetail({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  @override
  final QuoteViewModel viewModel;

  @override
  Widget build(BuildContext context) => widgetToRender;

  @override
  Quote get quote => viewModel.selectedQuote;

  @override
  bool get canViewDetail => false;
}
