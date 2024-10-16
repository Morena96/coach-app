import 'package:application/athletes/use_cases/create_group_use_case.dart';
import 'package:application/athletes/use_cases/create_new_athlete_use_case.dart';
import 'package:application/settings/use_cases/get_all_settings_use_case.dart';
import 'package:application/settings/use_cases/get_setting_use_case.dart';
import 'package:application/settings/use_cases/save_setting_use_case.dart';
import 'dart:io';

import 'package:coach_app/core/app_state.dart';
import 'package:coach_app/features/athletes/infrastructure/services/avatar_generator_service.dart';
import 'package:coach_app/features/athletes/presentation/providers/athletes_view_model.dart';
import 'package:coach_app/features/athletes/presentation/providers/sport_view_model.dart';
import 'package:coach_app/features/settings/presentation/providers/settings_view_model.dart';
import 'package:domain/features/athletes/data/athletes_service.dart';
import 'package:domain/features/athletes/data/groups_service.dart';
import 'package:domain/features/athletes/data/id_generator.dart';
import 'package:domain/features/athletes/data/sports_service.dart';
import 'package:domain/features/athletes/repositories/athletes.dart';
import 'package:domain/features/athletes/repositories/groups.dart';
import 'package:domain/features/athletes/repositories/sports.dart';
import 'package:domain/features/athletes/services/athlete_validation_service.dart';
import 'package:domain/features/avatars/repositories/avatar_repository.dart';
import 'package:domain/features/logging/repositories/logger.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  GoRouter,
  AppState,
  AppStateNotifier,
  SportViewModel,
  AthletesViewModel,
  SportsService,
  LoggerRepository,
  Sports,
  AvatarGeneratorService,
  AvatarRepository,
  Groups,
  SettingsViewModel,
  GetAllSettingsUseCase,
  GetSettingUseCase,
  SaveSettingUseCase,
  Directory,
  AthletesService,
  GroupsService,
  IdGenerator,
  GroupRoles,
  Athletes,
  AthleteValidationService,
  CreateNewAthleteUseCase,
  CreateGroupUseCase,
])
void main() {}

class GroupRoles {}

GoRouter router(Widget child) => GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => Scaffold(
            body: child,
          ),
        ),
      ],
    );
