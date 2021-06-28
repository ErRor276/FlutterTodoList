import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo_list/models/layout.dart';

class ResponsiveNotifier extends StateNotifier<Layout> {
  ResponsiveNotifier(state) : super(state);

  void size({required height, required width}) {}
}
