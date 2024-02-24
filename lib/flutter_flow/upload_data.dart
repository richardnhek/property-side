import 'dart:async';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime_type/mime_type.dart';
import '/backend/firebase_storage/storage.dart';
import 'package:video_player/video_player.dart';

import '../auth/firebase_auth/auth_util.dart';
// import 'flutter_flow_theme.dart';
import 'flutter_flow_util.dart';

// CUSTOM_CODE_STARTED
const allowedFormats = {
  'image/png',
  'image/jpeg',
  'video/mp4',
  'image/gif',
  'application/pdf',
  'application/msword',
  'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  'text/plain'
};

// CUSTOM_CODE_ENDED
class SelectedFile {
  const SelectedFile({
    this.storagePath = '',
    this.filePath,
    required this.bytes,
    this.dimensions,
    this.blurHash,
  });
  final String storagePath;
  final String? filePath;
  final Uint8List bytes;
  final MediaDimensions? dimensions;
  final String? blurHash;
}

class MediaDimensions {
  const MediaDimensions({
    this.height,
    this.width,
  });
  final double? height;
  final double? width;
}

enum MediaSource { photoGallery, videoGallery, camera, files }

// CUSTOM_CODE_STARTED
Future<List<SelectedFile>?> selectMediaWithSourceBottomSheet({
  required BuildContext context,
  String? storageFolderPath,
  double? maxWidth,
  double? maxHeight,
  int? imageQuality,
  required bool allowPhoto,
  bool allowVideo = false,
  String pickerFontFamily = 'Roboto',
  Color textColor = const Color(0xFF111417),
  Color backgroundColor = const Color(0xFFF5F5F5),
  bool includeDimensions = false,
  bool includeBlurHash = false,
}) async {
  final mediaSource = await showModalBottomSheet<MediaSource>(
      context: context,
      builder: (context) {
        return Container(
          width: double.infinity,
          height: 290.0,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(0.0),
              bottomRight: Radius.circular(0.0),
              topLeft: Radius.circular(10.0),
              topRight: Radius.circular(10.0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                width: 78.0,
                child: Divider(
                  thickness: 3.0,
                  color: Color(0x3557636C),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsetsDirectional.fromSTEB(16.0, 24.0, 16.0, 0.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 0.0, 5.0, 0.0),
                            child: Icon(
                              Icons.image_outlined,
                              color: Colors.black,
                              size: 24.0,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              'Photos & Videos',
                              style: GoogleFonts.inter(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 15.0, 7.5),
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(
                                context,
                                MediaSource.photoGallery,
                              );
                            },
                            child: Text(
                              'View photo library',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF51A781),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 15.0, 0.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(
                                context,
                                MediaSource.videoGallery,
                              );
                            },
                            child: Text(
                              'View video library',
                              style: GoogleFonts.inter(
                                color: const Color(0xFF51A781),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(
                    16.0, 20.0, 16.0, 20.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pop(
                          context,
                          MediaSource.camera,
                        );
                      },
                      child: Container(
                        width: 80.0,
                        height: 80.0,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: const Color(0x2F14181B),
                          ),
                        ),
                        child: Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.black,
                          size: 24.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                thickness: 1.0,
                color: Color(0x1514181B),
              ),
              Align(
                alignment: const AlignmentDirectional(-1.00, -1.00),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                      16.0, 0.0, 16.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            0.0, 0.0, 5.0, 0.0),
                        child: Icon(
                          Icons.link_outlined,
                          color: Colors.black,
                          size: 24.0,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(
                            context,
                            MediaSource.files,
                          );
                        },
                        child: Text(
                          'Upload Files',
                          style: GoogleFonts.inter(
                              fontSize: 16, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      });
  if (mediaSource == null) {
    return null;
  }
  if (mediaSource == MediaSource.files) {
    return selectFile(
        storageFolderPath: storageFolderPath,
        allowedExtensions: ['pdf', 'doc', 'docx', 'txt']);
  }
  return selectMedia(
    storageFolderPath: storageFolderPath,
    maxWidth: maxWidth,
    maxHeight: maxHeight,
    imageQuality: imageQuality,
    isVideo: mediaSource == MediaSource.videoGallery ||
        (mediaSource == MediaSource.camera && allowVideo && !allowPhoto),
    mediaSource: mediaSource,
    includeDimensions: includeDimensions,
    includeBlurHash: includeBlurHash,
  );
}

Future<List<SelectedFile>?> selectMedia({
  String? storageFolderPath,
  double? maxWidth,
  double? maxHeight,
  int? imageQuality,
  bool isVideo = false,
  MediaSource mediaSource = MediaSource.camera,
  bool multiImage = false,
  bool includeDimensions = false,
  bool includeBlurHash = false,
}) async {
  final picker = ImagePicker();

  if (multiImage) {
    final pickedMediaFuture = picker.pickMultiImage(
      maxWidth: maxWidth,
      maxHeight: maxHeight,
      imageQuality: imageQuality,
    );
    final pickedMedia = await pickedMediaFuture;
    if (pickedMedia.isEmpty) {
      return null;
    }

    return Future.wait(pickedMedia.asMap().entries.map((e) async {
      final index = e.key;
      final media = e.value;
      final mediaBytes = await media.readAsBytes();
      final path = _getStoragePath(storageFolderPath, media.name, false, index);
      final dimensions = includeDimensions
          ? isVideo
              ? _getVideoDimensions(media.path)
              : _getImageDimensions(mediaBytes)
          : null;

      return SelectedFile(
        storagePath: path,
        filePath: media.path,
        bytes: mediaBytes,
        dimensions: await dimensions,
      );
    }));
  }

  final source = mediaSource == MediaSource.camera
      ? ImageSource.camera
      : ImageSource.gallery;
  final pickedMediaFuture = isVideo
      ? picker.pickVideo(source: source)
      : picker.pickImage(
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: imageQuality,
          source: source,
        );
  final pickedMedia = await pickedMediaFuture;
  final mediaBytes = await pickedMedia?.readAsBytes();
  if (mediaBytes == null) {
    return null;
  }
  final path = _getStoragePath(storageFolderPath, pickedMedia!.name, isVideo);
  final dimensions = includeDimensions
      ? isVideo
          ? _getVideoDimensions(pickedMedia.path)
          : _getImageDimensions(mediaBytes)
      : null;

  return [
    SelectedFile(
      storagePath: path,
      filePath: pickedMedia.path,
      bytes: mediaBytes,
      dimensions: await dimensions,
    ),
  ];
}

bool validateFileFormat(String filePath, BuildContext context) {
  if (allowedFormats.contains(mime(filePath))) {
    return true;
  }
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text('Invalid file format: ${mime(filePath)}'),
    ));
  return false;
}

Future<List<SelectedFile>?> selectFile({
  String? storageFolderPath,
  List<String>? allowedExtensions,
}) =>
    selectFiles(
      storageFolderPath: storageFolderPath,
      allowedExtensions: allowedExtensions,
      multiFile: false,
    ).then((value) => value);

Future<List<SelectedFile>?> selectFiles({
  String? storageFolderPath,
  List<String>? allowedExtensions,
  bool multiFile = false,
}) async {
  final pickedFiles = await FilePicker.platform.pickFiles(
    type: allowedExtensions != null ? FileType.custom : FileType.any,
    allowedExtensions: allowedExtensions,
    withData: true,
    allowMultiple: multiFile,
  );
  if (pickedFiles == null || pickedFiles.files.isEmpty) {
    return null;
  }
  if (multiFile) {
    return Future.wait(pickedFiles.files.asMap().entries.map((e) async {
      final index = e.key;
      final file = e.value;
      final storagePath =
          _getStoragePath(storageFolderPath, file.name, false, index);
      return SelectedFile(
        storagePath: storagePath,
        filePath: isWeb ? null : file.path,
        bytes: file.bytes!,
      );
    }));
  }
  final file = pickedFiles.files.first;
  if (file.bytes == null) {
    return null;
  }
  final storagePath = _getStoragePath(storageFolderPath, file.name, false);
  return [
    SelectedFile(
      storagePath: storagePath,
      filePath: isWeb ? null : file.path,
      bytes: file.bytes!,
    )
  ];
}

List<SelectedFile> selectedFilesFromUploadedFiles(
  List<FFUploadedFile> uploadedFiles, {
  String? storageFolderPath,
  bool isMultiData = false,
}) =>
    uploadedFiles.asMap().entries.map(
      (entry) {
        final index = entry.key;
        final file = entry.value;
        return SelectedFile(
            storagePath: _getStoragePath(
              storageFolderPath,
              file.name!,
              false,
              isMultiData ? index : null,
            ),
            bytes: file.bytes!);
      },
    ).toList();

Future<MediaDimensions> _getImageDimensions(Uint8List mediaBytes) async {
  final image = await decodeImageFromList(mediaBytes);
  return MediaDimensions(
    width: image.width.toDouble(),
    height: image.height.toDouble(),
  );
}

Future<MediaDimensions> _getVideoDimensions(String path) async {
  final VideoPlayerController videoPlayerController =
      VideoPlayerController.asset(path);
  await videoPlayerController.initialize();
  final size = videoPlayerController.value.size;
  return MediaDimensions(width: size.width, height: size.height);
}

String _getStoragePath(
  String? pathPrefix,
  String filePath,
  bool isVideo, [
  int? index,
]) {
  pathPrefix ??= _firebasePathPrefix();
  pathPrefix = _removeTrailingSlash(pathPrefix);
  final timestamp = DateTime.now().microsecondsSinceEpoch;
  // Workaround fixed by https://github.com/flutter/plugins/pull/3685
  // (not yet in stable).
  final ext = isVideo ? 'mp4' : filePath.split('.').last;
  final indexStr = index != null ? '_$index' : '';
  return '$pathPrefix/$timestamp$indexStr.$ext';
}

String getSignatureStoragePath([String? pathPrefix]) {
  pathPrefix ??= _firebasePathPrefix();
  pathPrefix = _removeTrailingSlash(pathPrefix);
  final timestamp = DateTime.now().microsecondsSinceEpoch;
  return '$pathPrefix/signature_$timestamp.png';
}

void showUploadMessage(
  BuildContext context,
  String message, {
  bool showLoading = false,
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Row(
          children: [
            if (showLoading)
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 10.0),
                child: CircularProgressIndicator(
                  valueColor: Theme.of(context).brightness == Brightness.light
                      ? AlwaysStoppedAnimation<Color>(Colors.redAccent)
                      : null,
                ),
              ),
            Text(message),
          ],
        ),
        duration:
            showLoading ? const Duration(days: 1) : const Duration(seconds: 4),
      ),
    );
}

String? _removeTrailingSlash(String? path) => path != null && path.endsWith('/')
    ? path.substring(0, path.length - 1)
    : path;

String _firebasePathPrefix() => 'users/$currentUserUid/uploads';
// CUSTOM_CODE_ENDED