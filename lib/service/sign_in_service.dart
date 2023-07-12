import 'package:origination/models/response_status_dto.dart';
import 'package:origination/models/user_composite_dto.dart';

abstract class SignInService{

  Future<void> signIn(String userName, String password);

  Future<void> resetPasswordInit(String email);

  Future<void> checkResetKey(String token);

  Future<ResponseStatusDTO> resetPassword(UserCompositeDTO userCompositeDTO);
  
}