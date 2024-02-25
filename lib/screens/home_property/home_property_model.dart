import '/flutter_flow/flutter_flow_util.dart';
import 'home_property_widget.dart' show HomeProperty;
import 'package:flutter/material.dart';

class HomePropertyModel extends FlutterFlowModel<HomeProperty> {
  ///  Local state fields for this page.

  String selectedSite = 'https://www.realestate.com.au/';

  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  /// Initialization and disposal methods.

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
