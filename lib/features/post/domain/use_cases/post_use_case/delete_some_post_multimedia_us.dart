import 'package:dartz/dartz.dart';

import '../../../../../core_api/errors/failures.dart';
import '../../../../../core_api/success/success.dart';
import '../../Requsets/post_request/delete_some_post_multimedia_request.dart';
import '../../repositories/post_repository.dart';

class DeleteSomePostMultimediaUseCase {
  final PostRepository repository;

  DeleteSomePostMultimediaUseCase(this.repository);

  Future<Either<Failure, Success>> call(DeleteSomePostMultimediaRequest request) async {
    return await repository.deleteSomePostMultimedia(request);
  }
}