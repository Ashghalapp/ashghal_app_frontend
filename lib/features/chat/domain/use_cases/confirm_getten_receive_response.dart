// import 'package:ashghal_app_frontend/core_api/errors/failures.dart';
// import 'package:ashghal_app_frontend/features/chat/domain/entities/receive_read_confirmation.dart';
// import 'package:ashghal_app_frontend/features/chat/domain/repositories/message_repository.dart';
// import 'package:dartz/dartz.dart';

// class ConfirmGettenReceiveResponse {
//   final MessageRepository repository;
//   ConfirmGettenReceiveResponse({
//     required this.repository,
//   });

//   Future<Either<Failure, RecieveReadGotConfirmation>> call(
//       List<String> messagesIds) async {
//     return await repository.confirmGettenReceiveResponse(messagesIds);
//   }
// }