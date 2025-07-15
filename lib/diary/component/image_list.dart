import 'dart:io';
import 'package:women_diary/diary/component/aspect_video.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:women_diary/_gen/assets.gen.dart';
import 'package:mime/mime.dart';
import 'package:video_player/video_player.dart';

class ImageList extends StatefulWidget {
  ImageList({super.key, required this.imagePaths, required this.deletepath});

  List<String> imagePaths;
  Function(String) deletepath;

  @override
  State<ImageList> createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          childAspectRatio: 1.0,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0
      ),
      delegate: SliverChildBuilderDelegate((context, index) {
        final String? mime = lookupMimeType(widget.imagePaths[index]);
        bool isImage = mime == null || mime.startsWith('image/');
        Widget mediaContent = isImage ? _buildImageRow(index) : _buildVideoRow(index);
        return ClipRRect(
          borderRadius: BorderRadius.circular(10), // Image border
          child: SizedBox.fromSize(
            size: const Size.fromRadius(60), // Image radius
            child: Stack(
              children: [
                mediaContent,
                InkWell(
                  onTap: () {
                    widget.deletepath(widget.imagePaths[index]);
                  },
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      width: 30,
                      height: 30,
                      child: Assets.icons.delete.svg(width: 24, height: 24),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
        childCount: widget.imagePaths.length,
      ),
    );
  }

  Widget _buildVideoRow(int index) {
    final VideoPlayerController controller =
    VideoPlayerController.file(File(widget.imagePaths[index]));
    const double volume = 1.0;
    controller.setVolume(volume);
    controller.initialize();
    controller.setLooping(true);
    controller.play();
    return Center(child: AspectRatioVideo(controller));
  }

  Widget _buildImageRow(int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10), // Image border
      child: SizedBox.fromSize(
        size: const Size.fromRadius(60), // Image radius
        child: Image.file(
          File(widget.imagePaths[index]),
          errorBuilder: (BuildContext context, Object error,
              StackTrace? stackTrace) {
            return const Center(
                child: Text('This image type is not supported')
            );
          },
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}