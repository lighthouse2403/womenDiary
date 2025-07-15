import 'package:women_diary/common/constants/app_colors.dart';
import 'package:women_diary/common/extension/text_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui';

class BlocLoadingListener<B extends StateStreamable<S>, S> extends StatelessWidget {
  final Widget child;
  final bool Function(S previous, S current)? listenWhen;
  final bool Function(S state) isLoading;

  const BlocLoadingListener({
    super.key,
    required this.child,
    required this.isLoading,
    this.listenWhen,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<B, S>(
      listenWhen: listenWhen ?? (prev, curr) => isLoading(prev) != isLoading(curr),
      listener: (context, state) {
        if (isLoading(state)) {
          showGlassLoadingDialog(context);
        } else {
          hideLoadingDialog(context);
        }
      },
      child: child,
    );
  }

  void hideLoadingDialog(BuildContext context) {
    if (Navigator.of(context, rootNavigator: true).canPop()) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  void showGlassLoadingDialog(BuildContext context, {String? message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withAlpha(50),
      builder: (_) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Dialog(
          backgroundColor: Colors.white.withAlpha(20),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          elevation: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: AppColors.mainColor),
              const SizedBox(height: 16),
              Text(message ?? "Loading...").w500().text16().mainColor()
            ],
          ),
        ),
      ),
    );
  }
}
