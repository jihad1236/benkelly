import 'package:benkelly864/core/utils/constants/app_texts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/common/styles/global_text_style.dart';
import '../../../../core/utils/constants/colors.dart';
import '../../../core/common/widgets/custom_text_field.dart';
import '../controllers/add_to_collection_dialog_controller.dart';

class AddToCollectionDialog extends StatelessWidget {
  const AddToCollectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddToCollectionDialogController());

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      backgroundColor: AppColors.card,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  AppText.addToCollectionTitle,
                  style: getTextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: AppText.collectionName,
                      hintText: AppText.collectionNameHint,
                      controller: controller.folderController,
                      onChanged: controller.onFolderNameChanged,
                      fillColor: AppColors.card,
                      borderColor: AppColors.border,
                      hintColor: AppColors.textSecondary,
                      textColor: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Obx(
                    () => GestureDetector(
                      onTap: controller.isConfirmEnabled.value
                          ? controller.onConfirm
                          : null, // ✅ active only when folder name set
                      child: Container(
                        height: 44.h,
                        width: 44.h,
                        decoration: BoxDecoration(
                          color: controller.isConfirmEnabled.value
                              ? AppColors.mutedOlive
                              : AppColors.border, // inactive color
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: const Icon(Icons.check, color: AppColors.card),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }
}
