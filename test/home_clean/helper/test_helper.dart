import 'package:home_clean/domain/repositories/equipment_supply_repository.dart';
import 'package:home_clean/domain/repositories/house_repository.dart';
import 'package:home_clean/domain/repositories/authentication_repository.dart';
import 'package:home_clean/domain/repositories/building_repository.dart';
import 'package:home_clean/domain/repositories/order_repository.dart';
import 'package:home_clean/domain/repositories/room_repository.dart';
import 'package:home_clean/domain/repositories/service_repository.dart';
import 'package:home_clean/domain/repositories/transaction_repository.dart';
  import 'package:home_clean/domain/repositories/user_repository.dart';
import 'package:home_clean/domain/repositories/wallet_repository.dart';
import 'package:home_clean/domain/use_cases/auth/login_usecase.dart';
import 'package:home_clean/domain/use_cases/auth/user_register_usecase.dart';
import 'package:home_clean/domain/use_cases/building/get_buildings_use_case.dart';
import 'package:home_clean/domain/use_cases/equipment_supply/get_equipment_supplies_use_case.dart';
import 'package:home_clean/domain/use_cases/extra_service/get_extra_service_use_case.dart';
import 'package:home_clean/domain/use_cases/house/get_house_by_building_use_case.dart';
import 'package:home_clean/domain/use_cases/option/get_options_use_case.dart';
import 'package:home_clean/domain/use_cases/order/create_orders_use_case.dart';
import 'package:home_clean/domain/use_cases/room/get_rooms_usecase.dart';
import 'package:home_clean/domain/use_cases/service_activity/get_service_activities_by_service_usecase.dart';
import 'package:home_clean/domain/use_cases/service_category/get_service_by_service_category_usecase.dart';
import 'package:home_clean/domain/use_cases/service_category/get_service_categories_usecase.dart';
import 'package:home_clean/domain/use_cases/sub_activity/get_sub_activities_usecase.dart';
import 'package:home_clean/domain/use_cases/transaction/get_transaction_by_user.dart';
import 'package:home_clean/domain/use_cases/transaction/get_transaction_by_wallet_use_case.dart';
import 'package:home_clean/domain/use_cases/wallet/get_wallet_by_user.dart';
import 'package:mockito/annotations.dart';
  // flutter pub run build_runner build --delete-conflicting-outputs
  @GenerateMocks([
    AuthRepository,
    UserRepository,
    RoomRepository,
    BuildingRepository,
    WalletRepository,
    TransactionRepository,
    ServiceRepository,
    OrderRepository,
    HouseRepository,
    EquipmentSupplyRepository,

    /// UseCases
    GetBuildingsUseCase,
    GetRoomsUseCase,
    UserRegisterUseCase,
    LoginUseCase,
    CreateOrderUseCase,
    GetWalletByUserUseCase,
    GetEquipmentSuppliesUseCase,
    GetExtraServiceUseCase,
    GetOptionsUseCase,
    GetServiceActivitiesByServiceUsecase,
    GetSubActivitiesUsecase,
    GetServiceByServiceCategoryUsecase,
    GetServiceCategoriesUsecase,
    GetHouseByBuildingUseCase,
    GetTransactionByUserUseCase,
    GetTransactionByWalletUseCase,

    /// Data
  ], customMocks: [
  ])
  void main() {}


