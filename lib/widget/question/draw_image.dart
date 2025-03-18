import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';
import 'package:whats_this/service/draw_paint.dart';
import 'package:whats_this/widget/atoms/draw_painter/appbar.dart';
import 'package:whats_this/widget/atoms/draw_painter/drawing_area.dart';
import 'package:whats_this/widget/atoms/draw_painter/toolbar.dart';

class DrawImage extends StatefulWidget {
  const DrawImage({
    super.key,
    required this.onSaved,
  });

  final Function(File) onSaved;

  @override
  State<DrawImage> createState() => _DrawImageState();
}

class _DrawImageState extends State<DrawImage> {
  final List<Map<String, dynamic>> _points = [];
  Color _selectedColor = Colors.black;
  double _selectedStrokeWidth = 4.0;
  bool _isEraserMode = false;
  Offset? _eraserPosition;
  final DrawPaintService drawPaintService = DrawPaintService();

  void initParameter() {
    setState(() {
      _points.clear();
      _eraserPosition = null;
      _selectedColor = Colors.black;
      _selectedStrokeWidth = 4.0;
      _isEraserMode = false;
    });
  }

  void _pickColor() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('色選択'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: _selectedColor,
              onColorChanged: (color) {
                setState(() {
                  _selectedColor = color;
                });
              },
              enableAlpha: false,
              displayThumbColor: true,
              paletteType: PaletteType.hueWheel,
              labelTypes: [],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('選択'),
            ),
          ],
        );
      },
    );
  }

  Future<void> saveAndClose({required BuildContext context}) async {
    try {
      final file = await drawPaintService.saveToCache(
        context: context,
        points: _points,
        eraserPosition: _eraserPosition,
        isEraserMode: _isEraserMode,
        eraserSize: _selectedStrokeWidth,
      );
      widget.onSaved(file);
      Get.back();
    } catch (e) {
      log('이미지 저장 실패: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DrawPainterAppbawWidget(
        initParameter: initParameter,
        saveAndClose: saveAndClose,
      ),
      body: Column(
        children: [
          _buildToolbar(),
          const Divider(),
          _buildDrawingArea(),
        ],
      ),
    );
  }

  Widget _buildToolbar() {
    return ToolbarWidget(
      selectedColor: _selectedColor,
      onPickColor: _pickColor,
      selectedStrokeWidth: _selectedStrokeWidth,
      onStrokeWidthChanged: (int? newValue) {
        setState(() {
          _selectedStrokeWidth = newValue!.toDouble();
        });
      },
      isEraserMode: _isEraserMode,
      onToggleEraser: () {
        setState(() {
          _isEraserMode = !_isEraserMode;
        });
      },
    );
  }

  Widget _buildDrawingArea() {
    return Expanded(
      child: DrawingAreaWidget(
        points: _points,
        eraserPosition: _eraserPosition,
        isEraserMode: _isEraserMode,
        selectedStrokeWidth: _selectedStrokeWidth,
        selectedColor: _selectedColor,
        onPanUpdate: (Offset position) {
          setState(() {
            if (_isEraserMode) {
              _eraserPosition = position;
              _points.add({
                'offset': position,
                'color': Colors.white,
                'strokeWidth': _selectedStrokeWidth,
              });
            } else {
              _points.add({
                'offset': position,
                'color': _selectedColor,
                'strokeWidth': _selectedStrokeWidth,
              });
            }
          });
        },
        onPanEnd: () {
          setState(() {
            if (_isEraserMode) {
              _eraserPosition = null;
            } else {
              _points.add({'offset': null, 'color': null, 'strokeWidth': null});
            }
          });
        },
      ),
    );
  }
}
