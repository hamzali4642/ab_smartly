// Mocks generated by Mockito 5.3.2 from annotations
// in ab_smartly/context_event_handler.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:ab_smartly/context.dart' as _i4;
import 'package:ab_smartly/context_event_handler.dart' as _i2;
import 'package:ab_smartly/json/publish_event.dart' as _i5;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [ContextEventHandler].
///
/// See the documentation for Mockito's code generation for more information.
class MockContextEventHandler extends _i1.Mock
    implements _i2.ContextEventHandler {
  @override
  _i3.Future<void> publish(
    _i4.Context? context,
    _i5.PublishEvent? event,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #publish,
          [
            context,
            event,
          ],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
}