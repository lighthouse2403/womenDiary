import 'package:blur/blur.dart';
import 'package:flutter/material.dart';

class ModalBottomSheet {
  static void _showModalBottomSheet(context) {
    Size size = MediaQuery.of(context).size;
    showModalBottomSheet(
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
        context: context,
        builder: (BuildContext bc) {
          return Blur(
              child: Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/pregnancy_backgroound_3.jpg'),
                      fit: BoxFit.cover),
                ),
                child: Container(),
              )
          );
        });
  }
}