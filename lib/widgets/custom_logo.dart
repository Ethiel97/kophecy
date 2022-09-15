import 'package:flutter/material.dart';
import 'package:kophecy/utils/colors.dart';
import 'package:kophecy/utils/constants.dart';
import 'package:kophecy/utils/text_styles.dart';
import 'package:sizer/sizer.dart';

class CustomLogo extends StatelessWidget {
  const CustomLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        height: 25.w,
        width: 25.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.accentColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(Constants.kBorderRadius * 2),
        ),
        child: Text(
          Constants.appName.substring(0, 1),
          style: TextStyles.textStyle.apply(
            color: Colors.white,
            fontSizeDelta: 50,
            fontWeightDelta: 5,
          ),
        ),
      );
}
