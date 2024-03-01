import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/random_data_util.dart' as random_data;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'team_model.dart';
export 'team_model.dart';

class TeamWidget extends StatefulWidget {
  const TeamWidget({
    super.key,
  });

  @override
  State<TeamWidget> createState() => _TeamWidgetState();
}

class _TeamWidgetState extends State<TeamWidget> {
  late TeamModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TeamModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // context.watch<FFAppState>();

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBtnText,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          actions: [],
          flexibleSpace: FlexibleSpaceBar(
            background: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    child: Image.asset(
                      'assets/logo.png',
                      height: 35,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(15, 0, 0, 0),
                    child: Text(
                      'Buying Team',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Inter',
                            fontSize: 17,
                            lineHeight: 1.5,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            centerTitle: false,
            expandedTitleScale: 1.0,
          ),
          toolbarHeight: 75,
          elevation: 1,
        ),
        body: SingleChildScrollView(
          primary: false,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Divider(
                height: 1,
                thickness: 1,
                color: FlutterFlowTheme.of(context).darkGrey3,
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
                child: Text(
                  'Engaging with the Mortgage app team: your path to seamless home financing.',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Inter',
                        color: FlutterFlowTheme.of(context).darkGrey,
                        lineHeight: 1.5,
                      ),
                ),
              ),
              Divider(
                height: 40,
                thickness: 1,
                color: FlutterFlowTheme.of(context).darkGrey3,
              ),
              Align(
                alignment: AlignmentDirectional(-1, -1),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                        child: Text(
                          'Your Personal Team',
                          textAlign: TextAlign.start,
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    lineHeight: 1.5,
                                  ),
                        ),
                      ),
                      Text(
                        '(3)',
                        textAlign: TextAlign.start,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              lineHeight: 1.5,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: AlignmentDirectional(-1, -1),
                      child: Builder(
                        builder: (context) {
                          final personalTeamMembers = List.generate(
                                  random_data.randomInteger(4, 4),
                                  (index) => random_data.randomName(true, true))
                              .toList();
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:
                                  List.generate(personalTeamMembers.length,
                                      (personalTeamMembersIndex) {
                                final personalTeamMembersItem =
                                    personalTeamMembers[
                                        personalTeamMembersIndex];
                                return Container(
                                  constraints: BoxConstraints(
                                    maxWidth: 70,
                                  ),
                                  decoration: BoxDecoration(),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Image.network(
                                          random_data.randomImageUrl(
                                            65,
                                            65,
                                          ),
                                          width: double.infinity,
                                          height: 65,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 10, 0, 0),
                                        child: Text(
                                          personalTeamMembersItem,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Inter',
                                                fontSize: 14,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).divide(SizedBox(width: 15)),
                            ),
                          );
                        },
                      ),
                    ),
                  ].divide(SizedBox(width: 15)),
                ),
              ),
              Divider(
                height: 40,
                thickness: 1,
                color: FlutterFlowTheme.of(context).darkGrey3,
              ),
              Align(
                alignment: AlignmentDirectional(-1, -1),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                        child: Text(
                          'Your FinanceTeam',
                          textAlign: TextAlign.start,
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    lineHeight: 1.5,
                                  ),
                        ),
                      ),
                      Text(
                        '(3)',
                        textAlign: TextAlign.start,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              lineHeight: 1.5,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: AlignmentDirectional(-1, -1),
                      child: Builder(
                        builder: (context) {
                          final financeTeamMembers = List.generate(
                                  random_data.randomInteger(4, 4),
                                  (index) => random_data.randomName(true, true))
                              .toList();
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(financeTeamMembers.length,
                                  (financeTeamMembersIndex) {
                                final financeTeamMembersItem =
                                    financeTeamMembers[financeTeamMembersIndex];
                                return Container(
                                  constraints: BoxConstraints(
                                    maxWidth: 70,
                                  ),
                                  decoration: BoxDecoration(),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Image.network(
                                          random_data.randomImageUrl(
                                            65,
                                            65,
                                          ),
                                          width: double.infinity,
                                          height: 65,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 10, 0, 0),
                                        child: Text(
                                          financeTeamMembersItem,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Inter',
                                                fontSize: 14,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).divide(SizedBox(width: 15)),
                            ),
                          );
                        },
                      ),
                    ),
                  ].divide(SizedBox(width: 15)),
                ),
              ),
              Divider(
                height: 40,
                thickness: 1,
                color: FlutterFlowTheme.of(context).darkGrey3,
              ),
              Align(
                alignment: AlignmentDirectional(-1, -1),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                        child: Text(
                          'Your Buying Team',
                          textAlign: TextAlign.start,
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Inter',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    lineHeight: 1.5,
                                  ),
                        ),
                      ),
                      Text(
                        '(3)',
                        textAlign: TextAlign.start,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              lineHeight: 1.5,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20, 16, 20, 0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: AlignmentDirectional(-1, -1),
                      child: Builder(
                        builder: (context) {
                          final buyingTeamMembers = List.generate(
                                  random_data.randomInteger(4, 4),
                                  (index) => random_data.randomName(true, true))
                              .toList();
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(buyingTeamMembers.length,
                                  (buyingTeamMembersIndex) {
                                final buyingTeamMembersItem =
                                    buyingTeamMembers[buyingTeamMembersIndex];
                                return Container(
                                  constraints: BoxConstraints(
                                    maxWidth: 70,
                                  ),
                                  decoration: BoxDecoration(),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Image.network(
                                          random_data.randomImageUrl(
                                            65,
                                            65,
                                          ),
                                          width: double.infinity,
                                          height: 65,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 10, 0, 0),
                                        child: Text(
                                          buyingTeamMembersItem,
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Inter',
                                                fontSize: 14,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).divide(SizedBox(width: 15)),
                            ),
                          );
                        },
                      ),
                    ),
                  ].divide(SizedBox(width: 15)),
                ),
              ),
            ].addToEnd(SizedBox(height: 75)),
          ),
        ),
      ),
    );
  }
}
