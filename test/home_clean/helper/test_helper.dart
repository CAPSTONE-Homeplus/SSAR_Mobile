  import 'package:home_clean/domain/repositories/authentication_repository.dart';
import 'package:home_clean/domain/repositories/building_repository.dart';
import 'package:home_clean/domain/repositories/room_repository.dart';
  import 'package:home_clean/domain/repositories/user_repository.dart';
import 'package:home_clean/domain/usecases/auth/login_usecase.dart';
import 'package:home_clean/domain/usecases/auth/user_register_usecase.dart';
import 'package:home_clean/domain/usecases/building/get_buildings_usecase.dart';
import 'package:home_clean/domain/usecases/room/get_rooms_usecase.dart';
  import 'package:mockito/mockito.dart';
  import 'package:mockito/annotations.dart';

  @GenerateMocks([
    AuthRepository,
    UserRepository,
    RoomRepository,
    BuildingRepository,

    /// UseCases
    GetBuildingsUsecase,
    GetRoomsUseCase,
    UserRegisterUseCase,
    LoginUseCase
  ], customMocks: [
  ])
  void main() {}