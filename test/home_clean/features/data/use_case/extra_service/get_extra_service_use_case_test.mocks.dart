// Mocks generated by Mockito 5.4.5 from annotations
// in home_clean/test/home_clean/features/data/use_case/extra_service/get_extra_service_use_case_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i4;

import 'package:home_clean/core/base/base_model.dart' as _i2;
import 'package:home_clean/domain/entities/extra_service/extra_service.dart'
    as _i5;
import 'package:home_clean/domain/repositories/extra_service_repository.dart'
    as _i3;
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

class _FakeBaseResponse_0<T> extends _i1.SmartFake
    implements _i2.BaseResponse<T> {
  _FakeBaseResponse_0(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

/// A class which mocks [ExtraServiceRepository].
///
/// See the documentation for Mockito's code generation for more information.
class MockExtraServiceRepository extends _i1.Mock
    implements _i3.ExtraServiceRepository {
  MockExtraServiceRepository() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i4.Future<_i2.BaseResponse<_i5.ExtraService>> getExtraServices(
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
            returnValue: _i4.Future<_i2.BaseResponse<_i5.ExtraService>>.value(
              _FakeBaseResponse_0<_i5.ExtraService>(
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
          as _i4.Future<_i2.BaseResponse<_i5.ExtraService>>);
}
