import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:to_do/pages/setting/Widget/selected_option_widget.dart';
import 'package:to_do/pages/setting/Widget/unselected_option_widget.dart';

import '../../../core/provider/list_provider.dart';

class ThemeBottomSheet extends StatelessWidget {
  const ThemeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appProvider = Provider.of<ListProvider>(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
              onTap: () {
                appProvider.changeTheme(ThemeMode.light);
                Navigator.pop(context);
              },
              child: appProvider.isDarkEnabled()
                  ? UnSelectedOption(
                      titleUnselectedOption:
                          AppLocalizations.of(context)!.light)
                  : SelectedOption(
                      selectedTitle: AppLocalizations.of(context)!.light,
                    )),
          SizedBox(
            height: 30,
          ),
          InkWell(
              onTap: () {
                appProvider.changeTheme(ThemeMode.dark);
                Navigator.pop(context);
              },
              child: appProvider.isDarkEnabled()
                  ? SelectedOption(
                      selectedTitle: AppLocalizations.of(context)!.dark,
                    )
                  : UnSelectedOption(
                      titleUnselectedOption:
                          AppLocalizations.of(context)!.dark)),
        ],
      ),
    );
  }
}
