import 'package:flutter/material.dart';

extension ListViewExtension on ListView {
  Widget onLazyLoads(Future<void> Function() onPagingLoad,
      {Widget? itemLoadWidget}) {
    int itemCount = 0;
    if (childrenDelegate is SliverChildListDelegate) {
      throw Exception('Allowed only ListView');
    }

    final delegate = childrenDelegate as SliverChildBuilderDelegate;

    return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification notification) {
          if (notification.metrics.pixels ==
              notification.metrics.maxScrollExtent) {
            onPagingLoad();
          }
          return true;
        },
        child: ListView.builder(
          itemCount: itemCount,
          itemBuilder: (context, index) {
            if (index == (itemCount - 1)) {
              itemLoadWidget ??
                  const Center(
                    child: CircularProgressIndicator(),
                  );
            }
            return delegate.builder(context, index)!;
          },
        ));
  }
}
