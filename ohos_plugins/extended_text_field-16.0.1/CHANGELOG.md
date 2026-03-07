## 16.0.1

* Fix issue that context menu click didn't work on desktop(#250) 

## 16.0.0

* Migrate to Flutter 3.24.0

## 15.0.0

* Migrate to Flutter 3.22.0

## 14.0.0

* Migrate to Flutter 3.19.0
* Fix wrong postion of Magnifier

## 13.0.1

* Update readme about HarmonyOS

## 13.0.0

* Migrate to Flutter 3.16.0 (#229)
* Fix wrong caret position (#224,#226)

## 12.1.0

* Migrate to Flutter 3.13.0

## 12.0.1

* Fix issue that wrong cursor position on macos. (https://github.com/fluttercandies/extended_text_field/issues/210)

## 12.0.0

* Migrate to Flutter 3.10.0
* Refactoring codes and sync codes from 3.10.0
* Breaking change: 
  Remove [ExtendedText.textSelectionGestureDetectorBuilder],[ExtendedText.shouldShowSelectionHandles]
* Add ExtendedSelectableText   

## 11.0.1

* fix issue on ios after flutter version 3.7.0. #191 #198

## 11.0.0

* Migrate to 3.7.0

## 10.2.0

* Add TextInputBindingMixin to prevent system keyboard show.
* Add No SystemKeyboard demo

## 10.1.1

* Fix issue selection not right #172

## 10.1.0

* Migrate to 3.0.0
* Support Scribble Handwriting for iPads

## 10.0.1

* Public ExtendedTextFieldState and add bringIntoView method to support jump to caret when insert text with TextEditingController

## 10.0.0

* Migrate to 2.10.0.
* Add shouldShowSelectionHandles and textSelectionGestureDetectorBuilder call back to define the behavior of handles and toolbar.
* Shortcut support for web and desktop.

## 9.0.3

* Fix hittest is not right #131

## 9.0.2

* Fix selectionWidthStyle and selectionHeightStyle are not working.

## 9.0.1

* Support to use keyboard move cursor for SpecialInlineSpan. #135
* Fix issue that backspace delete two chars. #141

## 9.0.0

* Migrate to 2.8

## 8.0.0

* Add [SpecialTextSpan.mouseCursor], [SpecialTextSpan.onEnter] and [SpecialTextSpan.onExit].
* merge code from 2.2.0

## 7.0.1

* Fix issue that composing is not updated.#122

## 7.0.0

* Breaking change: [SpecialText.getContent] is not include endflag now.(please check if you call getContent and your endflag length is more than 1)
* Fix demo manualDelete error #120

## 6.0.1

* Fix issue that toolbar is not shown when double tap
* Fix throw exception when selectWordAtOffset

## 6.0.0

* Support null-safety

## 5.0.4

* Fix toolbar is not show after some behaviour #107

## 5.0.3

* Fix miss TextStyle for specialTextSpanBuilder #89

## 5.0.2

* Fix wrong position of caret

## 5.0.1

* change handleSpecialText to hasSpecialInlineSpanBase(extended_text_library)
* add hasPlaceholderSpan(extended_text_library)

## 5.0.0

* Merge from Flutter v1.22
* Support cursorHeight, onAppPrivateCommand, restorationId

## 4.0.0

* Merge from Flutter v1.20
* Support Autofill

## 3.0.1

* Fix issue that text is clipped when maxLine is 1 and width is more than maxWidth.(#67,#76)
* Fix issue that handles are not shown when the height of TextStyle is big than 1.0.(#49)

## 3.0.0

* Breaking change: fix typos OverflowWidget.

## 2.0.0

* Breaking change: extended_text_library has changed to support OverFlowWidget ExtendedText
* Fix textSelectionControls is not working.

## 1.0.1

* Fix wrong calculation about selection handles.

## 1.0.0

* Merge code from 1.17.0
* Fix analysis_options

## 0.5.0

* Fix error caret offset on ios.

## 0.4.9

* Fix error about TargetPlatform.macOS

## 0.4.8

* Fix issue that the cursor returns to the top when deleting quickly in Multi-line text
* Fix issue that toolbar will not show if autofocus is true when longpress

## 0.4.7

* Codes base on 1.12.13+hotfix.5
* Set limitation of flutter sdk >=1.12.13 <1.12.16
* Add demo that how to delete text with code
* Fix issue that not showing text while entering text from keyboard

## 0.4.6

* Remove TargetPlatform.macOS

## 0.4.5

* Fix build error for flutter sdk 1.12

## 0.4.4

* Fix wrong caret hegiht and postion
* Make Ios/Android caret the same height

## 0.4.3

* Fix kMinInteractiveSize is missing in high version of flutter

## 0.4.2

* Support custom selection toolbar and handles
* Improve codes about selection overlay
* Select all SpecialTextSpan(which deleteAll is true) when double tap or long tap
* Support WidgetSpan hitTest

## 0.4.1

* Fix issue that type 'ImageSpan' is not a subtype of type 'textSpan'(https://github.com/fluttercandies/extended_text_field/issues/13)

## 0.4.0

* Fix issue tgat WidgetSpan wrong offset(https://github.com/fluttercandies/extended_text_field/issues/11)
* Fix wrong caret offset

## 0.3.9

* Improve codes base on v1.7.8
* Support WidgetSpan (ExtendedWidgetSpan)

## 0.3.7

* Update extended_text_library

## 0.3.4

* Remove un-used codes in extended_text_selection

## 0.3.3

* Update extended_text_library

## 0.3.2

* Update path_provider 1.1.0

## 0.3.0

* Uncomment getFullHeightForCaret method for 1.5.4-hotfix.2
* Corret selection handles visibility for _updateSelectionExtentsVisibility method

## 0.2.8

* Corret selection handles position for image textspan
* StrutStyle strutStyle is obsoleted, it will lead to bugs for image span size.

## 0.2.7

* Fix selection handles blinking

## 0.2.6

* Take care when TextSpan children is null

## 0.2.5

* Update extended_text_library
1.Remove caretIn parameter(SpecialTextSpan)
2.DeleteAll parameter has the same effect as caretIn parameter(SpecialTextSpan)

## 0.2.4

* Fix caret position about image span
* Add caretIn parameter(whether caret can move into special text for SpecialTextSpan(like a image span or @xxxx)) for SpecialTextSpan

## 0.2.3

* Disabled informationCollector to keep backwards compatibility for now (ExtendedNetworkImageProvider)

## 0.2.2

* Fix caret position for last one image span
* Add image text demo
* Fix position for specialTex

## 0.2.1

* Fix caret position for image span

## 0.2.0

* Only iterate textSpan.children to find SpecialTextSpan

## 0.1.9

* Add BackgroundTextSpan, support to paint custom background

## 0.1.8

* Handle TextEditingValue's composing

## 0.1.6

* Improve codes to avoid unnecessary computation

## 0.1.5

* Override compareTo method in SpecialTextSpan and ImageSpan to
  Fix issue that image span or special text span was error rendering

## 0.1.4

* Update limitation
* Improve codes

## 0.1.3

* Update limitation
* Improve codes

## 0.1.1

* Support special text amd inline image
