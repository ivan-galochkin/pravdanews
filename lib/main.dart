import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pravda_news/domain/logger/logger.dart';
import 'package:pravda_news/presentation/app_root.dart';

void main() {
  initLogger();
  logger.info('Start main');
  runApp(
    const ProviderScope(child: App()),
  );
}
