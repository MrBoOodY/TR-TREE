import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tr_tree/constants/app_colors.dart';
import 'package:tr_tree/constants/app_themes.dart';
import 'package:tr_tree/view_models/shipp_comp_view_models/ship_comp_notification_view_model.dart';
import 'package:tr_tree/widgets/custom_app_header_widget.dart';
import 'package:tr_tree/widgets/loading_widget.dart';

class ShippCompNotificationTab extends StatefulWidget {
  const ShippCompNotificationTab({Key? key}) : super(key: key);

  @override
  State<ShippCompNotificationTab> createState() =>
      _ShippCompNotificationTabState();
}

class _ShippCompNotificationTabState extends State<ShippCompNotificationTab> {
  late Future<void> future;
  late ShipCompNotificationViewModel shipCompNotificationViewModel;
  @override
  void initState() {
    shipCompNotificationViewModel =
        Provider.of<ShipCompNotificationViewModel>(context, listen: false);

    future = shipCompNotificationViewModel.getNotifications();
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
                      itemCount: shipCompNotificationViewModel
                          .notificationMessages.length,
                      separatorBuilder: (_, __) => const Divider(
                        thickness: 1,
                      ),
                      itemBuilder: (_, index) => Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                shipCompNotificationViewModel
                                    .notificationMessages[index].title,
                                style: AppThemes.headTextStyleColored,
                              ),
                              const Spacer(),
                              Text(
                                DateFormat.yMd('ar').format(
                                    shipCompNotificationViewModel
                                        .notificationMessages[index].dateTime),
                                style: TextStyle(color: Colors.grey.shade600),
                              )
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Text(shipCompNotificationViewModel
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
