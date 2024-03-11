import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_web_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'home_property_model.dart';
export 'home_property_model.dart';

class HomeProperty extends StatefulWidget {
  const HomeProperty({super.key});

  @override
  _HomePropertyState createState() => _HomePropertyState();
}

class _HomePropertyState extends State<HomeProperty> {
  late HomePropertyModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePropertyModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    // context.watch<FFAppState>();

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: scaffoldKey,
          backgroundColor: FlutterFlowTheme.of(context).primaryBtnText,
          body: SafeArea(
            top: true,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: double.infinity,
                  height: 75.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                  ),
                  child: Align(
                    alignment: const AlignmentDirectional(-1.0, 1.0),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          20.0, 0.0, 0.0, 15.0),
                      child: Text(
                        'Search',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              fontSize: 17.0,
                              lineHeight: 1.5,
                            ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                        0.0, 0.0, 0.0, 15.0),
                    child: FlutterFlowWebView(
                      content: _model.selectedSite,
                      bypass: true,
                      height: 750.0,
                      verticalScroll: true,
                      horizontalScroll: false,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      25.0, 0.0, 25.0, 15.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          setState(() {
                            _model.selectedSite =
                                'https://www.realestate.com.au/';
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Please wait, loading site: ${_model.selectedSite}',
                                style: GoogleFonts.getFont(
                                  'Inter',
                                  color: FlutterFlowTheme.of(context).secondary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15.0,
                                ),
                              ),
                              duration: const Duration(milliseconds: 4000),
                              backgroundColor:
                                  FlutterFlowTheme.of(context).darkGrey,
                            ),
                          );
                        },
                        child: Material(
                          color: Colors.transparent,
                          elevation: 3.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Container(
                            width: 120.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                              color:
                                  FlutterFlowTheme.of(context).primaryBtnText,
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: Colors.transparent,
                                width: 0.0,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  10.0, 0.0, 10.0, 0.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(0.0),
                                child: Image.asset(
                                  'assets/rea-logo.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          setState(() {
                            _model.selectedSite = 'https://listingloop.com.au/';
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Please wait, loading site: ${_model.selectedSite}',
                                style: GoogleFonts.getFont(
                                  'Inter',
                                  color: FlutterFlowTheme.of(context).secondary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15.0,
                                ),
                              ),
                              duration: const Duration(milliseconds: 4000),
                              backgroundColor:
                                  FlutterFlowTheme.of(context).darkGrey,
                            ),
                          );
                        },
                        child: Material(
                          color: Colors.transparent,
                          elevation: 3.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Container(
                            width: 120.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                              color:
                                  FlutterFlowTheme.of(context).primaryBtnText,
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                color: Colors.transparent,
                                width: 0.0,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  10.0, 0.0, 10.0, 0.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(0.0),
                                child: Image.asset(
                                  'assets/listingloop.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
