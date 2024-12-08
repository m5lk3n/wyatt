import 'package:flutter_riverpod/flutter_riverpod.dart';

final arePermissionsGrantedStateProvider = StateProvider<bool>((ref) {
  return true; // optimistic to avoid indicating a premature error in appbar, set to false on demand in case of error
});
