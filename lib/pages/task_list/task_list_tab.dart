import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:to_do/pages/task_list/task_widget.dart';

import '../../core/provider/list_provider.dart';

class TaskListTab extends StatefulWidget {
  TaskListTab({super.key});

  @override
  State<TaskListTab> createState() => _TaskListTabState();
}

class _TaskListTabState extends State<TaskListTab> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var listProvider = Provider.of<ListProvider>(context);

    listProvider.getAllTasksFromFireStore();

    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context).size;
    return Column(
      children: [
        Stack(
          alignment: Alignment(0, 2.4),
          children: [
            Container(
              color: theme.primaryColor,
              width: double.infinity,
              height: mediaQuery.height * .21,
              padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 50),
              child: Text(
                AppLocalizations.of(context)!.to_do_list,
                style: theme.textTheme.titleLarge!
                    .copyWith(color: theme.colorScheme.onBackground),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
              margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white54,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: CalendarTimeline(
                initialDate: listProvider.selectDate,
                firstDate: DateTime.now().subtract(Duration(days: 365)),
                lastDate: DateTime.now().add(
                  const Duration(days: 365),
                ),
                onDateSelected: (date) {
                  listProvider.changeDate(date);
                },
                leftMargin: 20,
                monthColor: Colors.black87,
                dayColor: Colors.black87,
                activeDayColor: Colors.white,
                activeBackgroundDayColor: theme.colorScheme.primary,
                dotsColor: Colors.white,
                selectableDayPredicate: (date) => true,
                locale: 'en_ISO',
              ),
            ),
          ],
        ),
        SizedBox(height: mediaQuery.height * .04),
        Expanded(
          child: ListView.builder(
            itemBuilder: (context, index) {
              return TaskWidgetItem(
                task: listProvider.tasksList[index],
              );
            },
            itemCount: listProvider.tasksList.length,
          ),
        )
      ],
    );
  }
}
