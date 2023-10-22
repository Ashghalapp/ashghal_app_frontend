
import 'package:ashghal_app_frontend/features/post/domain/Requsets/pagination_request.dart';

class GetCommentRepliesRequest extends PaginationRequest{
  final int commentId;

  GetCommentRepliesRequest({required this.commentId,required super.pageNumber , required super.perPage});

  @override
  Map<String, Object> toJson(){
    return {
      'comment_id': commentId,
      ... super.toJson(),
    };
  }
}