import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:baby_diary/common/base/base_statefull_widget.dart';

class ImageRow extends BaseStatefulWidget {
  const ImageRow({super.key, required this.filePath});

  final String filePath;
  @override
  State<ImageRow> createState() => _ImageRowState();
}

class _ImageRowState extends BaseStatefulState<ImageRow> {

  @override
  Widget? buildBody() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6),
          borderRadius: const BorderRadius.all(Radius.circular(6))
      ),
      child: Stack(
        children: [
          Semantics(
              label: 'image_picker_example_picked_image',
              child: Image.file(
                File(widget.filePath),
                errorBuilder: (BuildContext context, Object error,
                    StackTrace? stackTrace) {
                  return const Center(
                      child:
                      Text('This image type is not supported'));
                },
                fit: BoxFit.cover,
              )
          )
        ],
      ),
    );
  }
}