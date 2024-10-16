import 'package:flutter/material.dart';
import 'package:flutter_date_range_picker/flutter_date_range_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

import 'package:coach_app/core/theme/app_colors.dart';
import 'package:coach_app/core/theme/app_text_style.dart';
import 'package:coach_app/l10n.dart';
import 'package:coach_app/shared/extensions/context.dart';
import 'package:coach_app/shared/utils/date_range.dart';

class RangeCalendar extends StatefulWidget {
  const RangeCalendar({
    super.key,
    required this.onDateSelected,
    this.selectedRange,
  });

  final void Function(DateTime? fromDate, DateTime? toDate) onDateSelected;
  final DateRange? selectedRange;

  @override
  State<RangeCalendar> createState() => _RangeCalendarState();
}

class _RangeCalendarState extends State<RangeCalendar> {
  final OverlayPortalController _overlayController = OverlayPortalController();
  final LayerLink _layerLink = LayerLink();
  DateRange? dateRange;

  @override
  void initState() {
    super.initState();
    dateRange = widget.selectedRange;
  }

  @override
  void didChangeDependencies() {
    setState(() {
      dateRange = widget.selectedRange;
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final buttons = [
      OutlinedButton(
        onPressed: _clearFilters,
        child: Text(
          context.l10n.resetFilter,
          style: AppTextStyle.primary12r,
        ),
      ),
      const SizedBox(
        width: 16,
        height: 8,
      ),
      ElevatedButton(
        onPressed: _applyFilters,
        child: Text(
          context.l10n.applyFilter,
          style: AppTextStyle.primary12r,
        ),
      ),
    ];

    return LayoutBuilder(builder: (context, constraints) {
      return CompositedTransformTarget(
        link: _layerLink,
        child: OverlayPortal(
          controller: _overlayController,
          overlayChildBuilder: (BuildContext context) {
            return Stack(
              children: [
                Positioned.fill(
                  child: GestureDetector(
                    onTap: _closeOverlay,
                    child: Container(color: Colors.transparent),
                  ),
                ),
                CompositedTransformFollower(
                  link: _layerLink,
                  targetAnchor: Alignment.bottomCenter,
                  followerAnchor: Alignment.topCenter,
                  offset: const Offset(0, 12),
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      width: context.isDesktop ? 812 : 322,
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: context.isDesktop ? 0 : 20,
                      ),
                      decoration: BoxDecoration(
                        color: context.color.tertiary,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: context.color.onSurface.withOpacity(.14),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          DateRangePickerWidget(
                            allowSingleTapDaySelection: true,
                            doubleMonth: context.isDesktop,
                            initialDateRange: dateRange,
                            quickDateRanges: context.isDesktop
                                ? getQuickDateRanges(context)
                                : [],
                            onDateRangeChanged: (range) => dateRange = range,
                            separatorThickness: 0,
                            theme: CalendarTheme(
                              separatorColor: Colors.transparent,
                              selectedQuickDateRangeColor:
                                  AppColors.primaryGreen,
                              selectedColor: AppColors.primaryGreen,
                              dayNameTextStyle: AppTextStyle.primary10r,
                              quickDateRangeTextStyle: AppTextStyle.primary14r,
                              inRangeColor:
                                  AppColors.primaryGreen.withOpacity(.2),
                              inRangeTextStyle: AppTextStyle.primary14r,
                              selectedTextStyle: AppTextStyle.primary14b
                                  .copyWith(color: AppColors.black),
                              todayTextStyle: AppTextStyle.primary14b,
                              defaultTextStyle: AppTextStyle.primary14r,
                              radius: 10,
                              tileSize: 40,
                              disabledTextStyle: AppTextStyle.secondary14r,
                              monthTextStyle: AppTextStyle.primary14b,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: context.isDesktop
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: buttons,
                                  )
                                : Column(children: buttons),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
          child: GestureDetector(
            onTap: _openOverlay,
            child: Container(
              width: 300,
              height: 44,
              padding: const EdgeInsets.fromLTRB(16, 3, 3, 3),
              decoration: BoxDecoration(
                border:
                    Border.all(color: context.color.onSurface.withOpacity(.5)),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        dateRange == null
                            ? context.l10n.date
                            : dateRange!.formatForLocale(context),
                        style: AppTextStyle.secondary16r.copyWith(
                          color: dateRange == null
                              ? context.color.onTertiary.withOpacity(.5)
                              : context.color.onSurface,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  SvgPicture.asset('assets/icons/calendar-circle.svg')
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  void _clearFilters() {
    _overlayController.hide();
    widget.onDateSelected(null, null);
    setState(() {
      dateRange = null;
    });
  }

  void _openOverlay() {
    _overlayController.show();
  }

  void _closeOverlay() {
    _overlayController.hide();
  }

  void _applyFilters() {
    _overlayController.hide();
    widget.onDateSelected(dateRange?.start, dateRange?.end);
    setState(() {});
  }
}
