import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../blocs/analytics_bloc/analytics_bloc.dart';
import '../blocs/journal_bloc/journal_bloc.dart';
import '../models/mood.dart';
import '../models/tag.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalyticsBloc, AnalyticsState>(
      builder: (BuildContext context, AnalyticsState state) {
        Text("Analytics Screen");
      },
    );
  }
}
