import 'package:dio/dio.dart';

class UploadRequest {
  final int messageLocalId;
  final CancelToken? cancelToken;
  final Function(int count, int total)? onSendProgress;
  UploadRequest({
    required this.messageLocalId,
    this.onSendProgress,
    this.cancelToken,
  });
}
