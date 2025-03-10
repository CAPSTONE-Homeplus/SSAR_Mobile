import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/domain/entities/activity_status/activity_status.dart';

import '../blocs/activity_status_bloc/activity_status_bloc.dart';

class ActivityStatusScreen extends StatefulWidget {
  @override
  State<ActivityStatusScreen> createState() => _ActivityStatusScreenState();
}

class _ActivityStatusScreenState extends State<ActivityStatusScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ActivityStatusBloc>().add(ConnectToHub()); // Auto-connect khi mở app
    context.read<ActivityStatusBloc>().add(LoadActivityStatuses());
  }

  @override
  void dispose() {
    context.read<ActivityStatusBloc>().add(DisconnectFromHub()); // Ngắt kết nối khi thoát
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activity Status'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              context.read<ActivityStatusBloc>().add(ClearAllActivityStatuses());
            },
          ),
        ],
      ),
      body: BlocBuilder<ActivityStatusBloc, ActivityStatusState>(
        builder: (context, state) {
          if (state is ActivityStatusLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ActivityStatusLoaded) {
            return _buildActivityStatusList(state.statuses);
          } else if (state is ActivityStatusError) {
            return Center(child: Text(state.message));
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              context.read<ActivityStatusBloc>().add(ConnectToHub());
            },
            child: Icon(Icons.connect_without_contact),
            tooltip: 'Connect to Hub',
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () {
              context.read<ActivityStatusBloc>().add(DisconnectFromHub());
            },
            child: Icon(Icons.add),
            tooltip: 'Disconnect from Hub',
          ),
        ],
      ),
    );
  }

  Widget _buildActivityStatusList(List<ActivityStatus> statuses) {
    return ListView.builder(
      itemCount: statuses.length,
      itemBuilder: (context, index) {
        final status = statuses[index];
        return ListTile(
          title: Text(status.activityId ?? ''),
          subtitle: Text(status.status ?? ''),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // Xử lý xóa một trạng thái cụ thể
            },
          ),
        );
      },
    );
  }
}