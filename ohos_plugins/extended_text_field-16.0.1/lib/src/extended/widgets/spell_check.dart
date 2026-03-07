part of 'package:extended_text_field/src/extended/widgets/text_field.dart';

/// [SpellCheckConfiguration]
class ExtendedSpellCheckConfiguration extends _SpellCheckConfiguration {
  /// Creates a configuration that specifies the service and suggestions handler
  /// for spell check.
  const ExtendedSpellCheckConfiguration({
    super.spellCheckService,
    super.misspelledSelectionColor,
    super.misspelledTextStyle,
    // super.spellCheckSuggestionsToolbarBuilder,
    this.extendedSpellCheckSuggestionsToolbarBuilder,
  });

  const ExtendedSpellCheckConfiguration.disabled()
      : extendedSpellCheckSuggestionsToolbarBuilder = null,
        super.disabled();

  /// {@template flutter.widgets.EditableText.contextMenuBuilder}
  /// Builds the text selection toolbar when requested by the user.
  ///
  /// `primaryAnchor` is the desired anchor position for the context menu, while
  /// `secondaryAnchor` is the fallback location if the menu doesn't fit.
  ///
  /// `buttonItems` represents the buttons that would be built by default for
  /// this widget.
  ///
  /// {@tool dartpad}
  /// This example shows how to customize the menu, in this case by keeping the
  /// default buttons for the platform but modifying their appearance.
  ///
  /// ** See code in examples/api/lib/material/context_menu/editable_text_toolbar_builder.0.dart **
  /// {@end-tool}
  ///
  /// {@tool dartpad}
  /// This example shows how to show a custom button only when an email address
  /// is currently selected.
  ///
  /// ** See code in examples/api/lib/material/context_menu/editable_text_toolbar_builder.1.dart **
  /// {@end-tool}
  ///
  /// See also:
  ///   * [AdaptiveTextSelectionToolbar], which builds the default text selection
  ///     toolbar for the current platform, but allows customization of the
  ///     buttons.
  ///   * [AdaptiveTextSelectionToolbar.getAdaptiveButtons], which builds the
  ///     button Widgets for the current platform given
  ///     [ContextMenuButtonItem]s.
  ///   * [BrowserContextMenu], which allows the browser's context menu on web
  ///     to be disabled and Flutter-rendered context menus to appear.
  /// {@endtemplate}
  ///
  /// If not provided, no context menu will be shown.
  final ExtendedEditableTextContextMenuBuilder?
      extendedSpellCheckSuggestionsToolbarBuilder;

  /// Returns a copy of the current [_SpellCheckConfiguration] instance with
  /// specified overrides.
  @override
  _SpellCheckConfiguration copyWith({
    SpellCheckService? spellCheckService,
    Color? misspelledSelectionColor,
    TextStyle? misspelledTextStyle,
    EditableTextContextMenuBuilder? spellCheckSuggestionsToolbarBuilder,
    ExtendedEditableTextContextMenuBuilder?
        extendedSpellCheckSuggestionsToolbarBuilder,
  }) {
    if (!_spellCheckEnabled) {
      // A new configuration should be constructed to enable spell check.
      return const _SpellCheckConfiguration.disabled();
    }

    return ExtendedSpellCheckConfiguration(
      spellCheckService: spellCheckService ?? this.spellCheckService,
      misspelledSelectionColor:
          misspelledSelectionColor ?? this.misspelledSelectionColor,
      misspelledTextStyle: misspelledTextStyle ?? this.misspelledTextStyle,
      extendedSpellCheckSuggestionsToolbarBuilder:
          extendedSpellCheckSuggestionsToolbarBuilder ??
              this.extendedSpellCheckSuggestionsToolbarBuilder,
      // spellCheckSuggestionsToolbarBuilder:
      //     spellCheckSuggestionsToolbarBuilder ??
      //         this.spellCheckSuggestionsToolbarBuilder,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is ExtendedSpellCheckConfiguration &&
        other.spellCheckService == spellCheckService &&
        other.misspelledTextStyle == misspelledTextStyle &&
        other.spellCheckSuggestionsToolbarBuilder ==
            spellCheckSuggestionsToolbarBuilder &&
        other._spellCheckEnabled == _spellCheckEnabled &&
        other.extendedSpellCheckSuggestionsToolbarBuilder ==
            extendedSpellCheckSuggestionsToolbarBuilder;
  }

  @override
  int get hashCode => Object.hash(
        spellCheckService,
        misspelledTextStyle,
        spellCheckSuggestionsToolbarBuilder,
        _spellCheckEnabled,
        extendedSpellCheckSuggestionsToolbarBuilder,
      );
}
