import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';


class MyIcons {
  MyIcons._();

  static const _kFontFam = 'MyIcons';
  static const String? _kFontPkg = null;

  static const IconData veryHappy =
      IconData(0xe8e3, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData Happy =
      IconData(0xe8e1, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData normal =
      IconData(0xe8e4, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData verybad =
      IconData(0xe8e5, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}