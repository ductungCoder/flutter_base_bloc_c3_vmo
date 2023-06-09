// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// Project imports:
import '../../../app/app.dart';
import '../bloc/list_user_bloc.dart';

// Project imports:

class ListUserScreen extends StatefulWidget {
  const ListUserScreen({Key? key}) : super(key: key);

  @override
  _ListUserScreenState createState() {
    return _ListUserScreenState();
  }
}

class _ListUserScreenState extends State<ListUserScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(
          "List User",
          style: TextStyleManager.label3,
        ),
        automaticallyImplyLeading: false,
      ),
      body: BlocConsumer<ListUserBloc, ListUserState>(
        listener: (context, state) {
          switch (state.runtimeType) {
            case LoadingListUser:
              break;
            case ShowListUser:
              _refreshController.refreshCompleted();
              _refreshController.loadComplete();
              break;
          }
        },
        buildWhen: (_, current) => current is ShowListUser,
        builder: (context, state) {
          if (state is ShowListUser) {
            return SmartRefresher(
              controller: _refreshController,
              enablePullDown: true,
              enablePullUp: true,
              onRefresh: () => context.read<ListUserBloc>().add(GetListUser()),
              onLoading: () => context.read<ListUserBloc>().add(LoadMoreUser()),
              child: ListView.separated(
                itemBuilder: (context, index) => Center(
                  child: Text(
                    "User $index",
                    style: TextStyleManager.label3,
                  ),
                ),
                separatorBuilder: (context, index) => const Divider(),
                itemCount: state.listUser.length,
              ),
            );
          }

          return Container();
        },
      ),
    );
  }
}
