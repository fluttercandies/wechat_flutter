// ignore_for_file: always_put_control_body_on_new_line

import 'package:example/special_text/my_extended_text_selection_controls.dart';
import 'package:example/special_text/my_special_text_span_builder.dart';
import 'package:extended_text_field/extended_text_field.dart';
import 'package:ff_annotation_route_library/ff_annotation_route_library.dart';
import 'package:flutter/material.dart';

///
///  create by zmtzawqlp on 2019/7/31
///

@FFRoute(
  name: 'fluttercandies://CustomToolBar',
  routeName: 'custom toolbar',
  description: 'custom selection toolbar and handles for text field',
  exts: <String, dynamic>{
    'group': 'Simple',
    'order': 0,
  },
)
class CustomToolBar extends StatefulWidget {
  @override
  _CustomToolBarState createState() => _CustomToolBarState();
}

class _CustomToolBarState extends State<CustomToolBar> {
  final MyTextSelectionControls _myExtendedMaterialTextSelectionControls =
      MyTextSelectionControls();
  final MySpecialTextSpanBuilder _mySpecialTextSpanBuilder =
      MySpecialTextSpanBuilder();
  TextEditingController controller = TextEditingController()
    ..text =
        '[33]Extended text field help you to build rich text quickly. any special text you will have with extended text. this is demo to show how to create custom toolbar and handles.'
            '\n\nIt\'s my pleasure to invite you to join \$FlutterCandies\$ if you want to improve flutter .[36]'
            '\n\nif you meet any problem, please let me konw @zmtzawqlp .[44]';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('custom selection toolbar handles'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Center(
          child: ExtendedTextField(
            selectionControls: _myExtendedMaterialTextSelectionControls,
            specialTextSpanBuilder: _mySpecialTextSpanBuilder,
            extendedContextMenuBuilder:
                MyTextSelectionControls.defaultContextMenuBuilder,
            controller: controller,
            maxLines: null,
            // StrutStyle get strutStyle {
            //   if (_strutStyle == null) {
            //     return StrutStyle.fromTextStyle(style, forceStrutHeight: true);
            //   }
            //   return _strutStyle!.inheritFromTextStyle(style);
            // }
            // default strutStyle is not good for WidgetSpan
            strutStyle: const StrutStyle(),
            // shouldShowSelectionHandles: _shouldShowSelectionHandles,
            // textSelectionGestureDetectorBuilder: ({
            //   required ExtendedTextSelectionGestureDetectorBuilderDelegate
            //       delegate,
            //   required Function showToolbar,
            //   required Function hideToolbar,
            //   required Function? onTap,
            //   required BuildContext context,
            //   required Function? requestKeyboard,
            // }) {
            //   return MyCommonTextSelectionGestureDetectorBuilder(
            //     delegate: delegate,
            //     showToolbar: showToolbar,
            //     hideToolbar: hideToolbar,
            //     onTap: onTap,
            //     context: context,
            //     requestKeyboard: requestKeyboard,
            //   );
            // },
          ),
        ),
      ),
    );
  }

//   bool _shouldShowSelectionHandles(
//     SelectionChangedCause? cause,
//     CommonTextSelectionGestureDetectorBuilder selectionGestureDetectorBuilder,
//     TextEditingValue editingValue,
//   ) {
//     // When the text field is activated by something that doesn't trigger the
//     // selection overlay, we shouldn't show the handles either.

//     //
//     // if (!selectionGestureDetectorBuilder.shouldShowSelectionToolbar)
//     //   return false;

//     if (cause == SelectionChangedCause.keyboard) return false;

//     // if (widget.readOnly && _effectiveController.selection.isCollapsed)
//     //   return false;

//     // if (!_isEnabled) return false;

//     if (cause == SelectionChangedCause.longPress) return true;

//     if (editingValue.text.isNotEmpty) return true;

//     return false;
//   }
}

// class MyCommonTextSelectionGestureDetectorBuilder
//     extends CommonTextSelectionGestureDetectorBuilder {
//   MyCommonTextSelectionGestureDetectorBuilder(
//       {required ExtendedTextSelectionGestureDetectorBuilderDelegate delegate,
//       required Function showToolbar,
//       required Function hideToolbar,
//       required Function? onTap,
//       required BuildContext context,
//       required Function? requestKeyboard})
//       : super(
//           delegate: delegate,
//           showToolbar: showToolbar,
//           hideToolbar: hideToolbar,
//           onTap: onTap,
//           context: context,
//           requestKeyboard: requestKeyboard,
//         );
//   @override
//   void onTapDown(TapDragDownDetails details) {
//     super.onTapDown(details);

//     /// always show toolbar
//     shouldShowSelectionToolbar = true;
//   }

//   @override
//   bool get showToolbarInWeb => true;
// }
