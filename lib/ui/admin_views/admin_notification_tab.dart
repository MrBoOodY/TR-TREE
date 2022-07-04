import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tr_tree/constants/app_colors.dart';
import 'package:tr_tree/constants/app_themes.dart';
import 'package:tr_tree/view_models/admin_view_models/admin_notification_view_model.dart';
import 'package:tr_tree/widgets/custom_app_header_widget.dart';
import 'package:tr_tree/widgets/loading_widget.dart';

class AdminNotificationTab extends StatefulWidget {
  const AdminNotificationTab({Key? key}) : super(key: key);

  @override
  State<AdminNotificationTab> createState() => _AdminNotificationTabState();
}

class _AdminNotificationTabState extends State<AdminNotificationTab> {
  late Future<void> future;
  late AdminNotificationViewModel adminNotificationViewModel;
  @override
  void initState() {
    adminNotificationViewModel =
        Provider.of<AdminNotificationViewModel>(context, listen: false);

    future = adminNotificationViewModel.getNotifications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CustomAppHeaderWidget(title: 'الإشعارات'),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: FutureBuilder(
              future: future,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                  case ConnectionState.active:
                    return ListView.separated(
                      itemCount: adminNotificationViewModel
                          .notificationMessages.length,
                      separatorBuilder: (_, __) => const Divider(
                        thickness: 1,
                      ),
                      itemBuilder: (_, index) => Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                adminNotificationViewModel
                                    .notificationMessages[index].title,
                                style: AppThemes.headTextStyleColored,
                              ),
                              const Spacer(),
                              Text(
                                DateFormat.yMd('ar').format(
                                    adminNotificationViewModel
                                        .notificationMessages[index].dateTime),
                                style: TextStyle(color: Colors.grey.shade600),
                              )
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Text(adminNotificationViewModel
                              .notificationMessages[index].body),
                        ],
                      ),
                    );
                  case ConnectionState.waiting:
                  default:
                    return const LoadingWidget(
                      color: AppColors.splashScreenColor,
                    );
                }
              },
            ),
          ),
        )
      ],
    );
  }
}
