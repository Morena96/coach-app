import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:coach_app/core/app_state.dart';
import 'package:coach_app/core/router/routes.dart';
import 'package:coach_app/core/widgets/image_cropper.dart';
import 'package:coach_app/features/auth/presentation/providers/auth_notifier.dart';
import 'package:coach_app/l10n.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.homePage),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context.pushNamed(Routes.helloWorld.name);
                },
                child: Text(context.l10n.themeShowcase),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => context.pushNamed(Routes.map.name),
                child: const Text('Map'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => context.pushNamed(Routes.timer.name),
                child: const Text('Timer Demo'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () =>
                    context.pushNamed(Routes.viewSampleGpsData.name),
                child: Text(context.l10n.viewSampleGpsData),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => context.pushNamed(Routes.antennaSystem.name),
                child: Text(context.l10n.antennaSystemPage),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => context.pushNamed(Routes.antennaDebug.name),
                child: Text(context.l10n.antennaDebugPage),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => context.pushNamed(Routes.antennaControl.name),
                child: Text(context.l10n.antennaControlPage),
              ),
              const SizedBox(height: 20),
              Text(appState.isConnected
                  ? context.l10n.connected
                  : context.l10n.notConnected),
              const SizedBox(height: 20),
              ElevatedButton(
                child: Text(context.l10n.selectImage),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => ImageCropper(
                      onCropComplete: (Uint8List croppedImage) {},
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: ref.read(authNotifierProvider.notifier).logout,
                child: Text(context.l10n.logOut),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
