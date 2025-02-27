import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theming/colors.dart';
import '../../../../core/theming/styles.dart';

class UnitDropdown extends StatefulWidget {
  @override
  _UnitDropdownState createState() => _UnitDropdownState();
}

class _UnitDropdownState extends State<UnitDropdown> {
  bool isExpanded = false;
  String selectedUnit = 'unit';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 46.w,
      height: 109.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Unit selector button
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Container(
              height: 31.h,
              width: 46.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topRight: Radius.circular(9.r)),
                color: ColorsManager.colorContainer,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 6.w,
                  ),
                  Center(
                    child: Text(
                      selectedUnit,
                      style: TextStyles.font8WhiteSemiBold,
                    ),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Expanded(
                    child: Container(
                      width: 14.w,
                      height: 14.w,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: ColorsManager.colorCircle,
                      ),
                      child: const Center(
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Colors.black,
                            size: 13,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Dropdown menu
          if (isExpanded)
            Column(
              children: [
                SizedBox(
                  height: 8.h,
                ),
                _buildUnitOption('meter'),
                SizedBox(
                  height: 8.h,
                ),
                _buildUnitOption('cm'),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildUnitOption(String unit) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedUnit = unit;
          isExpanded = false;
        });
      },
      child: Container(
        height: 31.h,
        width: 46.w,
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        decoration: BoxDecoration(
          color: ColorsManager.colorContainer,
        ),
        child: Center(
          child: Text(
            unit,
            style: TextStyles.font8WhiteSemiBold,
          ),
        ),
      ),
    );
  }
}
