import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

String? passwordValidator(String? value) => value!.length < 6
    ? AppLocalizations.of(Get.context!)!.password_at_least_6_characters
    : null;

String? validator(String? value) => value!.isEmpty
    ? AppLocalizations.of(Get.context!)!.field_cannot_be_empty
    : null;

String? usernameValidator(String? value) => value!.length < 4
    ? AppLocalizations.of(Get.context!)!.pseudo_at_least_4_characters
    : null;

String? emailValidator(String? value) => (value!.isEmpty || !value.isEmail)
    ? AppLocalizations.of(Get.context!)!.enter_valid_email
    : null;
