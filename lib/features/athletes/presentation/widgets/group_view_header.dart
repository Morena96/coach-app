import 'package:flutter/material.dart';

import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:coach_app/core/widgets/avatar_image.dart';
import 'package:coach_app/features/athletes/presentation/models/group_view.dart';
import 'package:coach_app/shared/extensions/context.dart';

class GroupViewHeader extends StatelessWidget {
  const GroupViewHeader({
    super.key,
    required this.group,
  });
  final GroupView group;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        children: [
          AvatarImage(
            avatarPath: group.avatarId ?? '',
            size: context.isMobile ? 40 : 66,
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    group.name,
                    style: context.isMobile
                        ? AppTextStyle.primary18b
                        : AppTextStyle.primary26b,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if ((group.description ?? '').isNotEmpty)
                  Text(
                    group.description!,
                    style: AppTextStyle.secondary14r,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
