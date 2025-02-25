// Mocks generated by Mockito 5.4.5 from annotations
// in home_clean/test/home_clean/helper/test_helper.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i12;

import 'package:dartz/dartz.dart' as _i8;
import 'package:home_clean/core/base/base_model.dart' as _i4;
import 'package:home_clean/core/exception/failure.dart' as _i32;
import 'package:home_clean/data/models/auth/login_model.dart' as _i13;
import 'package:home_clean/domain/entities/auth/auth.dart' as _i3;
import 'package:home_clean/domain/entities/building/building.dart' as _i17;
import 'package:home_clean/domain/entities/equipment_supply/equipment_supply.dart'
    as _i28;
import 'package:home_clean/domain/entities/extra_service/extra_service.dart'
    as _i30;
import 'package:home_clean/domain/entities/house/house.dart' as _i26;
import 'package:home_clean/domain/entities/option/option.dart' as _i41;
import 'package:home_clean/domain/entities/order/create_order.dart' as _i24;
import 'package:home_clean/domain/entities/order/order.dart' as _i6;
import 'package:home_clean/domain/entities/room/room.dart' as _i16;
import 'package:home_clean/domain/entities/service/service.dart' as _i23;
import 'package:home_clean/domain/entities/service_activity/service_activity.dart'
    as _i43;
import 'package:home_clean/domain/entities/service_category/service_category.dart'
    as _i48;
import 'package:home_clean/domain/entities/sub_activity/sub_activity.dart'
    as _i45;
import 'package:home_clean/domain/entities/transaction/create_transaction.dart'
    as _i21;
import 'package:home_clean/domain/entities/transaction/transaction.dart' as _i5;
import 'package:home_clean/domain/entities/user/create_user.dart' as _i14;
import 'package:home_clean/domain/entities/user/user.dart' as _i2;
import 'package:home_clean/domain/entities/wallet/wallet.dart' as _i19;
import 'package:home_clean/domain/repositories/authentication_repository.dart'
    as _i11;
import 'package:home_clean/domain/repositories/building_repository.dart' as _i7;
import 'package:home_clean/domain/repositories/equipment_supply_repository.dart'
    as _i27;
import 'package:home_clean/domain/repositories/extra_service_repository.dart'
    as _i29;
import 'package:home_clean/domain/repositories/house_repository.dart' as _i25;
import 'package:home_clean/domain/repositories/order_repository.dart' as _i10;
import 'package:home_clean/domain/repositories/room_repository.dart' as _i9;
import 'package:home_clean/domain/repositories/service_repository.dart' as _i22;
import 'package:home_clean/domain/repositories/transaction_repository.dart'
    as _i20;
import 'package:home_clean/domain/repositories/user_repository.dart' as _i15;
import 'package:home_clean/domain/repositories/wallet_repository.dart' as _i18;
import 'package:home_clean/domain/use_cases/auth/login_usecase.dart' as _i35;
import 'package:home_clean/domain/use_cases/auth/user_register_usecase.dart'
    as _i34;
import 'package:home_clean/domain/use_cases/building/get_buildings_use_case.dart'
    as _i31;
import 'package:home_clean/domain/use_cases/equipment_supply/get_equipment_supplies_use_case.dart'
    as _i38;
import 'package:home_clean/domain/use_cases/extra_service/get_extra_service_use_case.dart'
    as _i39;
import 'package:home_clean/domain/use_cases/house/get_house_by_building_use_case.dart'
    as _i49;
import 'package:home_clean/domain/use_cases/option/get_options_use_case.dart'
    as _i40;
import 'package:home_clean/domain/use_cases/order/create_orders_use_case.dart'
    as _i36;
import 'package:home_clean/domain/use_cases/room/get_rooms_usecase.dart'
    as _i33;
import 'package:home_clean/domain/use_cases/service_activity/get_service_activities_by_service_usecase.dart'
    as _i42;
import 'package:home_clean/domain/use_cases/service_category/get_service_by_service_category_usecase.dart'
    as _i46;
import 'package:home_clean/domain/use_cases/service_category/get_service_categories_usecase.dart'
    as _i47;
import 'package:home_clean/domain/use_cases/sub_activity/get_sub_activities_usecase.dart'
    as _i44;
import 'package:home_clean/domain/use_cases/transaction/get_transaction_by_user.dart'
    as _i50;
import 'package:home_clean/domain/use_cases/transaction/get_transaction_by_wallet_use_case.dart'
    as _i51;
import 'package:home_clean/domain/use_cases/wallet/get_wallet_by_user.dart'
    as _i37;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeUser_0 extends _i1.SmartFake implements _i2.User {
  _FakeUser_0(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeAuth_1 extends _i1.SmartFake implements _i3.Auth {
  _FakeAuth_1(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeBaseResponse_2<T> extends _i1.SmartFake
    implements _i4.BaseResponse<T> {
  _FakeBaseResponse_2(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeTransaction_3 extends _i1.SmartFake implements _i5.Transaction {
  _FakeTransaction_3(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeOrders_4 extends _i1.SmartFake implements _i6.Orders {
  _FakeOrders_4(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeBuildingRepository_5 extends _i1.SmartFake
    implements _i7.BuildingRepository {
  _FakeBuildingRepository_5(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeEither_6<L, R> extends _i1.SmartFake implements _i8.Either<L, R> {
  _FakeEither_6(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeRoomRepository_7 extends _i1.SmartFake
    implements _i9.RoomRepository {
  _FakeRoomRepository_7(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeOrderRepository_8 extends _i1.SmartFake
    implements _i10.OrderRepository {
  _FakeOrderRepository_8(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

/// A class which mocks [AuthRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockAuthRepository extends _i1.Mock implements _i11.AuthRepository {
  MockAuthRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i12.Future<bool> login(_i13.LoginModel? loginModel) =>
      (super.noSuchMethod(
            Invocation.method(#login, [loginModel]),
            returnValue: _i12.Future<bool>.value(false),
          )
          as _i12.Future<bool>);

  @override
  _i12.Future<_i2.User> createAccount(_i14.CreateUser? createUser) =>
      (super.noSuchMethod(
            Invocation.method(#createAccount, [createUser]),
            returnValue: _i12.Future<_i2.User>.value(
              _FakeUser_0(
                this,
                Invocation.method(#createAccount, [createUser]),
              ),
            ),
          )
          as _i12.Future<_i2.User>);

  @override
  _i12.Future<_i3.Auth> refreshToken() =>
      (super.noSuchMethod(
            Invocation.method(#refreshToken, []),
            returnValue: _i12.Future<_i3.Auth>.value(
              _FakeAuth_1(this, Invocation.method(#refreshToken, [])),
            ),
          )
          as _i12.Future<_i3.Auth>);

  @override
  _i12.Future<_i2.User> getUserFromLocal() =>
      (super.noSuchMethod(
            Invocation.method(#getUserFromLocal, []),
            returnValue: _i12.Future<_i2.User>.value(
              _FakeUser_0(this, Invocation.method(#getUserFromLocal, [])),
            ),
          )
          as _i12.Future<_i2.User>);
}

/// A class which mocks [UserRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserRepository extends _i1.Mock implements _i15.UserRepository {
  MockUserRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i12.Future<_i2.User> createAccount(_i14.CreateUser? createUser) =>
      (super.noSuchMethod(
            Invocation.method(#createAccount, [createUser]),
            returnValue: _i12.Future<_i2.User>.value(
              _FakeUser_0(
                this,
                Invocation.method(#createAccount, [createUser]),
              ),
            ),
          )
          as _i12.Future<_i2.User>);

  @override
  _i12.Future<_i2.User> getUser(String? userId) =>
      (super.noSuchMethod(
            Invocation.method(#getUser, [userId]),
            returnValue: _i12.Future<_i2.User>.value(
              _FakeUser_0(this, Invocation.method(#getUser, [userId])),
            ),
          )
          as _i12.Future<_i2.User>);
}

/// A class which mocks [RoomRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockRoomRepository extends _i1.Mock implements _i9.RoomRepository {
  MockRoomRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i12.Future<_i4.BaseResponse<_i16.Room>> getRooms(
    String? search,
    String? orderBy,
    int? page,
    int? size,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#getRooms, [search, orderBy, page, size]),
            returnValue: _i12.Future<_i4.BaseResponse<_i16.Room>>.value(
              _FakeBaseResponse_2<_i16.Room>(
                this,
                Invocation.method(#getRooms, [search, orderBy, page, size]),
              ),
            ),
          )
          as _i12.Future<_i4.BaseResponse<_i16.Room>>);
}

/// A class which mocks [BuildingRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockBuildingRepository extends _i1.Mock
    implements _i7.BuildingRepository {
  MockBuildingRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i12.Future<_i4.BaseResponse<_i17.Building>> getBuildings(
    String? search,
    String? orderBy,
    int? page,
    int? size,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#getBuildings, [search, orderBy, page, size]),
            returnValue: _i12.Future<_i4.BaseResponse<_i17.Building>>.value(
              _FakeBaseResponse_2<_i17.Building>(
                this,
                Invocation.method(#getBuildings, [search, orderBy, page, size]),
              ),
            ),
          )
          as _i12.Future<_i4.BaseResponse<_i17.Building>>);
}

/// A class which mocks [WalletRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockWalletRepository extends _i1.Mock implements _i18.WalletRepository {
  MockWalletRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i12.Future<_i4.BaseResponse<_i19.Wallet>> getWalletByUser(
    int? page,
    int? size,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#getWalletByUser, [page, size]),
            returnValue: _i12.Future<_i4.BaseResponse<_i19.Wallet>>.value(
              _FakeBaseResponse_2<_i19.Wallet>(
                this,
                Invocation.method(#getWalletByUser, [page, size]),
              ),
            ),
          )
          as _i12.Future<_i4.BaseResponse<_i19.Wallet>>);
}

/// A class which mocks [TransactionRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockTransactionRepository extends _i1.Mock
    implements _i20.TransactionRepository {
  MockTransactionRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i12.Future<_i5.Transaction> saveTransaction(
    _i21.CreateTransaction? transaction,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#saveTransaction, [transaction]),
            returnValue: _i12.Future<_i5.Transaction>.value(
              _FakeTransaction_3(
                this,
                Invocation.method(#saveTransaction, [transaction]),
              ),
            ),
          )
          as _i12.Future<_i5.Transaction>);

  @override
  _i12.Future<_i4.BaseResponse<_i5.Transaction>> getTransactionByUser(
    String? search,
    String? orderBy,
    int? page,
    int? size,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#getTransactionByUser, [
              search,
              orderBy,
              page,
              size,
            ]),
            returnValue: _i12.Future<_i4.BaseResponse<_i5.Transaction>>.value(
              _FakeBaseResponse_2<_i5.Transaction>(
                this,
                Invocation.method(#getTransactionByUser, [
                  search,
                  orderBy,
                  page,
                  size,
                ]),
              ),
            ),
          )
          as _i12.Future<_i4.BaseResponse<_i5.Transaction>>);

  @override
  _i12.Future<_i4.BaseResponse<_i5.Transaction>> getTransactionByUserWallet(
    String? walletId,
    String? search,
    String? orderBy,
    int? page,
    int? size,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#getTransactionByUserWallet, [
              walletId,
              search,
              orderBy,
              page,
              size,
            ]),
            returnValue: _i12.Future<_i4.BaseResponse<_i5.Transaction>>.value(
              _FakeBaseResponse_2<_i5.Transaction>(
                this,
                Invocation.method(#getTransactionByUserWallet, [
                  walletId,
                  search,
                  orderBy,
                  page,
                  size,
                ]),
              ),
            ),
          )
          as _i12.Future<_i4.BaseResponse<_i5.Transaction>>);
}

/// A class which mocks [ServiceRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockServiceRepository extends _i1.Mock implements _i22.ServiceRepository {
  MockServiceRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i12.Future<_i4.BaseResponse<_i23.Service>> getServices(
    String? search,
    String? orderBy,
    int? page,
    int? size,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#getServices, [search, orderBy, page, size]),
            returnValue: _i12.Future<_i4.BaseResponse<_i23.Service>>.value(
              _FakeBaseResponse_2<_i23.Service>(
                this,
                Invocation.method(#getServices, [search, orderBy, page, size]),
              ),
            ),
          )
          as _i12.Future<_i4.BaseResponse<_i23.Service>>);

  @override
  _i12.Future<void> saveSelectedServiceIds(List<String>? ids) =>
      (super.noSuchMethod(
            Invocation.method(#saveSelectedServiceIds, [ids]),
            returnValue: _i12.Future<void>.value(),
            returnValueForMissingStub: _i12.Future<void>.value(),
          )
          as _i12.Future<void>);

  @override
  _i12.Future<List<String>?> getSelectedServiceIds() =>
      (super.noSuchMethod(
            Invocation.method(#getSelectedServiceIds, []),
            returnValue: _i12.Future<List<String>?>.value(),
          )
          as _i12.Future<List<String>?>);

  @override
  _i12.Future<void> clearSelectedServiceIds() =>
      (super.noSuchMethod(
            Invocation.method(#clearSelectedServiceIds, []),
            returnValue: _i12.Future<void>.value(),
            returnValueForMissingStub: _i12.Future<void>.value(),
          )
          as _i12.Future<void>);
}

/// A class which mocks [OrderRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockOrderRepository extends _i1.Mock implements _i10.OrderRepository {
  MockOrderRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i12.Future<_i6.Orders> createOrder(_i24.CreateOrder? createOrder) =>
      (super.noSuchMethod(
            Invocation.method(#createOrder, [createOrder]),
            returnValue: _i12.Future<_i6.Orders>.value(
              _FakeOrders_4(
                this,
                Invocation.method(#createOrder, [createOrder]),
              ),
            ),
          )
          as _i12.Future<_i6.Orders>);

  @override
  _i12.Future<void> saveOrderToLocal(_i24.CreateOrder? createOrder) =>
      (super.noSuchMethod(
            Invocation.method(#saveOrderToLocal, [createOrder]),
            returnValue: _i12.Future<void>.value(),
            returnValueForMissingStub: _i12.Future<void>.value(),
          )
          as _i12.Future<void>);

  @override
  _i12.Future<_i6.Orders?> getOrderFromLocal() =>
      (super.noSuchMethod(
            Invocation.method(#getOrderFromLocal, []),
            returnValue: _i12.Future<_i6.Orders?>.value(),
          )
          as _i12.Future<_i6.Orders?>);

  @override
  _i12.Future<void> deleteOrderFromLocal() =>
      (super.noSuchMethod(
            Invocation.method(#deleteOrderFromLocal, []),
            returnValue: _i12.Future<void>.value(),
            returnValueForMissingStub: _i12.Future<void>.value(),
          )
          as _i12.Future<void>);
}

/// A class which mocks [HouseRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockHouseRepository extends _i1.Mock implements _i25.HouseRepository {
  MockHouseRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i12.Future<_i4.BaseResponse<_i26.House>> getHouseByBuilding(
    String? buildingId,
    String? search,
    String? orderBy,
    int? page,
    int? size,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#getHouseByBuilding, [
              buildingId,
              search,
              orderBy,
              page,
              size,
            ]),
            returnValue: _i12.Future<_i4.BaseResponse<_i26.House>>.value(
              _FakeBaseResponse_2<_i26.House>(
                this,
                Invocation.method(#getHouseByBuilding, [
                  buildingId,
                  search,
                  orderBy,
                  page,
                  size,
                ]),
              ),
            ),
          )
          as _i12.Future<_i4.BaseResponse<_i26.House>>);
}

/// A class which mocks [EquipmentSupplyRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockEquipmentSupplyRepository extends _i1.Mock
    implements _i27.EquipmentSupplyRepository {
  MockEquipmentSupplyRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i12.Future<_i4.BaseResponse<_i28.EquipmentSupply>> getEquipmentSupplies(
    String? serviceId,
    String? search,
    String? orderBy,
    int? page,
    int? size,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#getEquipmentSupplies, [
              serviceId,
              search,
              orderBy,
              page,
              size,
            ]),
            returnValue:
                _i12.Future<_i4.BaseResponse<_i28.EquipmentSupply>>.value(
                  _FakeBaseResponse_2<_i28.EquipmentSupply>(
                    this,
                    Invocation.method(#getEquipmentSupplies, [
                      serviceId,
                      search,
                      orderBy,
                      page,
                      size,
                    ]),
                  ),
                ),
          )
          as _i12.Future<_i4.BaseResponse<_i28.EquipmentSupply>>);
}

/// A class which mocks [ExtraServiceRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockExtraServiceRepository extends _i1.Mock
    implements _i29.ExtraServiceRepository {
  MockExtraServiceRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i12.Future<_i4.BaseResponse<_i30.ExtraService>> getExtraServices(
    String? serviceId,
    String? search,
    String? orderBy,
    int? page,
    int? size,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#getExtraServices, [
              serviceId,
              search,
              orderBy,
              page,
              size,
            ]),
            returnValue: _i12.Future<_i4.BaseResponse<_i30.ExtraService>>.value(
              _FakeBaseResponse_2<_i30.ExtraService>(
                this,
                Invocation.method(#getExtraServices, [
                  serviceId,
                  search,
                  orderBy,
                  page,
                  size,
                ]),
              ),
            ),
          )
          as _i12.Future<_i4.BaseResponse<_i30.ExtraService>>);
}

/// A class which mocks [GetBuildingsUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetBuildingsUseCase extends _i1.Mock
    implements _i31.GetBuildingsUseCase {
  MockGetBuildingsUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i7.BuildingRepository get buildingRepository =>
      (super.noSuchMethod(
            Invocation.getter(#buildingRepository),
            returnValue: _FakeBuildingRepository_5(
              this,
              Invocation.getter(#buildingRepository),
            ),
          )
          as _i7.BuildingRepository);

  @override
  _i12.Future<_i8.Either<_i32.Failure, _i4.BaseResponse<_i17.Building>>>
  execute(_i31.GetBuildingsParams? params) =>
      (super.noSuchMethod(
            Invocation.method(#execute, [params]),
            returnValue: _i12.Future<
              _i8.Either<_i32.Failure, _i4.BaseResponse<_i17.Building>>
            >.value(
              _FakeEither_6<_i32.Failure, _i4.BaseResponse<_i17.Building>>(
                this,
                Invocation.method(#execute, [params]),
              ),
            ),
          )
          as _i12.Future<
            _i8.Either<_i32.Failure, _i4.BaseResponse<_i17.Building>>
          >);
}

/// A class which mocks [GetRoomsUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetRoomsUseCase extends _i1.Mock implements _i33.GetRoomsUseCase {
  MockGetRoomsUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i9.RoomRepository get roomRepository =>
      (super.noSuchMethod(
            Invocation.getter(#roomRepository),
            returnValue: _FakeRoomRepository_7(
              this,
              Invocation.getter(#roomRepository),
            ),
          )
          as _i9.RoomRepository);

  @override
  _i12.Future<_i8.Either<_i32.Failure, _i4.BaseResponse<_i16.Room>>> call(
    _i33.GetRoomsParams? params,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#call, [params]),
            returnValue: _i12.Future<
              _i8.Either<_i32.Failure, _i4.BaseResponse<_i16.Room>>
            >.value(
              _FakeEither_6<_i32.Failure, _i4.BaseResponse<_i16.Room>>(
                this,
                Invocation.method(#call, [params]),
              ),
            ),
          )
          as _i12.Future<
            _i8.Either<_i32.Failure, _i4.BaseResponse<_i16.Room>>
          >);
}

/// A class which mocks [UserRegisterUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockUserRegisterUseCase extends _i1.Mock
    implements _i34.UserRegisterUseCase {
  MockUserRegisterUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i12.Future<_i8.Either<_i32.Failure, _i2.User>> execute(
    _i14.CreateUser? createUser,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#execute, [createUser]),
            returnValue: _i12.Future<_i8.Either<_i32.Failure, _i2.User>>.value(
              _FakeEither_6<_i32.Failure, _i2.User>(
                this,
                Invocation.method(#execute, [createUser]),
              ),
            ),
          )
          as _i12.Future<_i8.Either<_i32.Failure, _i2.User>>);
}

/// A class which mocks [LoginUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockLoginUseCase extends _i1.Mock implements _i35.LoginUseCase {
  MockLoginUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i12.Future<_i8.Either<_i32.Failure, bool>> call(
    _i13.LoginModel? loginModel,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#call, [loginModel]),
            returnValue: _i12.Future<_i8.Either<_i32.Failure, bool>>.value(
              _FakeEither_6<_i32.Failure, bool>(
                this,
                Invocation.method(#call, [loginModel]),
              ),
            ),
          )
          as _i12.Future<_i8.Either<_i32.Failure, bool>>);
}

/// A class which mocks [CreateOrderUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockCreateOrderUseCase extends _i1.Mock
    implements _i36.CreateOrderUseCase {
  MockCreateOrderUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i10.OrderRepository get repository =>
      (super.noSuchMethod(
            Invocation.getter(#repository),
            returnValue: _FakeOrderRepository_8(
              this,
              Invocation.getter(#repository),
            ),
          )
          as _i10.OrderRepository);

  @override
  _i12.Future<_i8.Either<_i32.Failure, _i6.Orders>> execute(
    _i36.SaveOrderParams? params,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#execute, [params]),
            returnValue:
                _i12.Future<_i8.Either<_i32.Failure, _i6.Orders>>.value(
                  _FakeEither_6<_i32.Failure, _i6.Orders>(
                    this,
                    Invocation.method(#execute, [params]),
                  ),
                ),
          )
          as _i12.Future<_i8.Either<_i32.Failure, _i6.Orders>>);
}

/// A class which mocks [GetWalletByUserUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetWalletByUserUseCase extends _i1.Mock
    implements _i37.GetWalletByUserUseCase {
  MockGetWalletByUserUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i12.Future<_i4.BaseResponse<_i19.Wallet>> execute(int? page, int? size) =>
      (super.noSuchMethod(
            Invocation.method(#execute, [page, size]),
            returnValue: _i12.Future<_i4.BaseResponse<_i19.Wallet>>.value(
              _FakeBaseResponse_2<_i19.Wallet>(
                this,
                Invocation.method(#execute, [page, size]),
              ),
            ),
          )
          as _i12.Future<_i4.BaseResponse<_i19.Wallet>>);
}

/// A class which mocks [GetEquipmentSuppliesUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetEquipmentSuppliesUseCase extends _i1.Mock
    implements _i38.GetEquipmentSuppliesUseCase {
  MockGetEquipmentSuppliesUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i12.Future<_i8.Either<_i32.Failure, _i4.BaseResponse<_i28.EquipmentSupply>>>
  execute(
    String? serviceId,
    String? search,
    String? orderBy,
    int? page,
    int? size,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#execute, [
              serviceId,
              search,
              orderBy,
              page,
              size,
            ]),
            returnValue: _i12.Future<
              _i8.Either<_i32.Failure, _i4.BaseResponse<_i28.EquipmentSupply>>
            >.value(
              _FakeEither_6<
                _i32.Failure,
                _i4.BaseResponse<_i28.EquipmentSupply>
              >(
                this,
                Invocation.method(#execute, [
                  serviceId,
                  search,
                  orderBy,
                  page,
                  size,
                ]),
              ),
            ),
          )
          as _i12.Future<
            _i8.Either<_i32.Failure, _i4.BaseResponse<_i28.EquipmentSupply>>
          >);
}

/// A class which mocks [GetExtraServiceUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetExtraServiceUseCase extends _i1.Mock
    implements _i39.GetExtraServiceUseCase {
  MockGetExtraServiceUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i12.Future<_i8.Either<_i32.Failure, _i4.BaseResponse<_i30.ExtraService>>>
  execute(
    String? serviceId,
    String? search,
    String? orderBy,
    int? page,
    int? size,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#execute, [
              serviceId,
              search,
              orderBy,
              page,
              size,
            ]),
            returnValue: _i12.Future<
              _i8.Either<_i32.Failure, _i4.BaseResponse<_i30.ExtraService>>
            >.value(
              _FakeEither_6<_i32.Failure, _i4.BaseResponse<_i30.ExtraService>>(
                this,
                Invocation.method(#execute, [
                  serviceId,
                  search,
                  orderBy,
                  page,
                  size,
                ]),
              ),
            ),
          )
          as _i12.Future<
            _i8.Either<_i32.Failure, _i4.BaseResponse<_i30.ExtraService>>
          >);
}

/// A class which mocks [GetOptionsUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetOptionsUseCase extends _i1.Mock implements _i40.GetOptionsUseCase {
  MockGetOptionsUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i12.Future<_i4.BaseResponse<_i41.Option>> execute(
    String? serviceId,
    String? search,
    String? orderBy,
    int? page,
    int? size,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#execute, [
              serviceId,
              search,
              orderBy,
              page,
              size,
            ]),
            returnValue: _i12.Future<_i4.BaseResponse<_i41.Option>>.value(
              _FakeBaseResponse_2<_i41.Option>(
                this,
                Invocation.method(#execute, [
                  serviceId,
                  search,
                  orderBy,
                  page,
                  size,
                ]),
              ),
            ),
          )
          as _i12.Future<_i4.BaseResponse<_i41.Option>>);
}

/// A class which mocks [GetServiceActivitiesByServiceUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetServiceActivitiesByServiceUsecase extends _i1.Mock
    implements _i42.GetServiceActivitiesByServiceUsecase {
  MockGetServiceActivitiesByServiceUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i12.Future<_i4.BaseResponse<_i43.ServiceActivity>> execute(
    String? serviceId,
    String? search,
    String? orderBy,
    int? page,
    int? size,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#execute, [
              serviceId,
              search,
              orderBy,
              page,
              size,
            ]),
            returnValue:
                _i12.Future<_i4.BaseResponse<_i43.ServiceActivity>>.value(
                  _FakeBaseResponse_2<_i43.ServiceActivity>(
                    this,
                    Invocation.method(#execute, [
                      serviceId,
                      search,
                      orderBy,
                      page,
                      size,
                    ]),
                  ),
                ),
          )
          as _i12.Future<_i4.BaseResponse<_i43.ServiceActivity>>);
}

/// A class which mocks [GetSubActivitiesUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetSubActivitiesUsecase extends _i1.Mock
    implements _i44.GetSubActivitiesUsecase {
  MockGetSubActivitiesUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i12.Future<_i4.BaseResponse<_i45.SubActivity>> execute(
    String? serviceActivityId,
    String? search,
    String? orderBy,
    int? page,
    int? size,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#execute, [
              serviceActivityId,
              search,
              orderBy,
              page,
              size,
            ]),
            returnValue: _i12.Future<_i4.BaseResponse<_i45.SubActivity>>.value(
              _FakeBaseResponse_2<_i45.SubActivity>(
                this,
                Invocation.method(#execute, [
                  serviceActivityId,
                  search,
                  orderBy,
                  page,
                  size,
                ]),
              ),
            ),
          )
          as _i12.Future<_i4.BaseResponse<_i45.SubActivity>>);
}

/// A class which mocks [GetServiceByServiceCategoryUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetServiceByServiceCategoryUsecase extends _i1.Mock
    implements _i46.GetServiceByServiceCategoryUsecase {
  MockGetServiceByServiceCategoryUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i12.Future<_i4.BaseResponse<_i23.Service>> execute(
    String? serviceCategoryId,
    String? search,
    String? orderBy,
    int? page,
    int? size,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#execute, [
              serviceCategoryId,
              search,
              orderBy,
              page,
              size,
            ]),
            returnValue: _i12.Future<_i4.BaseResponse<_i23.Service>>.value(
              _FakeBaseResponse_2<_i23.Service>(
                this,
                Invocation.method(#execute, [
                  serviceCategoryId,
                  search,
                  orderBy,
                  page,
                  size,
                ]),
              ),
            ),
          )
          as _i12.Future<_i4.BaseResponse<_i23.Service>>);
}

/// A class which mocks [GetServiceCategoriesUsecase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetServiceCategoriesUsecase extends _i1.Mock
    implements _i47.GetServiceCategoriesUsecase {
  MockGetServiceCategoriesUsecase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i12.Future<_i4.BaseResponse<_i48.ServiceCategory>> execute(
    String? search,
    String? orderBy,
    int? page,
    int? size,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#execute, [search, orderBy, page, size]),
            returnValue:
                _i12.Future<_i4.BaseResponse<_i48.ServiceCategory>>.value(
                  _FakeBaseResponse_2<_i48.ServiceCategory>(
                    this,
                    Invocation.method(#execute, [search, orderBy, page, size]),
                  ),
                ),
          )
          as _i12.Future<_i4.BaseResponse<_i48.ServiceCategory>>);
}

/// A class which mocks [GetHouseByBuildingUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetHouseByBuildingUseCase extends _i1.Mock
    implements _i49.GetHouseByBuildingUseCase {
  MockGetHouseByBuildingUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i12.Future<_i4.BaseResponse<_i26.House>> execute(
    String? buildingId,
    String? search,
    String? orderBy,
    int? page,
    int? size,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#execute, [
              buildingId,
              search,
              orderBy,
              page,
              size,
            ]),
            returnValue: _i12.Future<_i4.BaseResponse<_i26.House>>.value(
              _FakeBaseResponse_2<_i26.House>(
                this,
                Invocation.method(#execute, [
                  buildingId,
                  search,
                  orderBy,
                  page,
                  size,
                ]),
              ),
            ),
          )
          as _i12.Future<_i4.BaseResponse<_i26.House>>);
}

/// A class which mocks [GetTransactionByUserUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetTransactionByUserUseCase extends _i1.Mock
    implements _i50.GetTransactionByUserUseCase {
  MockGetTransactionByUserUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i12.Future<_i8.Either<_i32.Failure, _i4.BaseResponse<_i5.Transaction>>>
  call({String? search, String? orderBy, int? page, int? size}) =>
      (super.noSuchMethod(
            Invocation.method(#call, [], {
              #search: search,
              #orderBy: orderBy,
              #page: page,
              #size: size,
            }),
            returnValue: _i12.Future<
              _i8.Either<_i32.Failure, _i4.BaseResponse<_i5.Transaction>>
            >.value(
              _FakeEither_6<_i32.Failure, _i4.BaseResponse<_i5.Transaction>>(
                this,
                Invocation.method(#call, [], {
                  #search: search,
                  #orderBy: orderBy,
                  #page: page,
                  #size: size,
                }),
              ),
            ),
          )
          as _i12.Future<
            _i8.Either<_i32.Failure, _i4.BaseResponse<_i5.Transaction>>
          >);
}

/// A class which mocks [GetTransactionByWalletUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetTransactionByWalletUseCase extends _i1.Mock
    implements _i51.GetTransactionByWalletUseCase {
  MockGetTransactionByWalletUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i12.Future<_i8.Either<_i32.Failure, _i4.BaseResponse<_i5.Transaction>>> call(
    String? walletId,
    String? search,
    String? orderBy,
    int? page,
    int? size,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#call, [walletId, search, orderBy, page, size]),
            returnValue: _i12.Future<
              _i8.Either<_i32.Failure, _i4.BaseResponse<_i5.Transaction>>
            >.value(
              _FakeEither_6<_i32.Failure, _i4.BaseResponse<_i5.Transaction>>(
                this,
                Invocation.method(#call, [
                  walletId,
                  search,
                  orderBy,
                  page,
                  size,
                ]),
              ),
            ),
          )
          as _i12.Future<
            _i8.Either<_i32.Failure, _i4.BaseResponse<_i5.Transaction>>
          >);
}
