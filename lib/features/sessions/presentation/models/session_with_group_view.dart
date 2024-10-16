import 'package:coach_app/features/athletes/presentation/models/group_view.dart';
import 'package:coach_app/features/sessions/presentation/models/session_view.dart';

class SessionWithGroupView {
  final SessionView session;
  final GroupView group;

  SessionWithGroupView({required this.session, required this.group});
}
