import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/core/router/app_router.dart';
import 'package:home_clean/domain/entities/wallet/wallet.dart';
import 'package:home_clean/presentation/blocs/auth/auth_event.dart';
import 'package:home_clean/presentation/blocs/building/building_event.dart';
import 'package:home_clean/presentation/blocs/house/house_event.dart';
import 'package:home_clean/presentation/blocs/house/house_state.dart';
import 'package:home_clean/presentation/blocs/service/service_bloc.dart';
import 'package:home_clean/presentation/blocs/wallet/wallet_bloc.dart';
import 'package:home_clean/presentation/blocs/wallet/wallet_state.dart';
import 'package:home_clean/presentation/screens/home/components/home_screen_body.dart';
import 'package:home_clean/presentation/screens/home/components/home_screen_loading.dart';

import '../../../domain/entities/building/building.dart';
import '../../../domain/entities/house/house.dart';
import '../../../domain/entities/user/user.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/building/building_bloc.dart';
import '../../blocs/building/building_state.dart';
import '../../blocs/house/house_bloc.dart';
import '../../blocs/wallet/wallet_event.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late WalletBloc _walletBloc;
  late AuthBloc _authBloc;
  late HouseBloc _houseBloc;
  late BuildingBloc _buildingBloc;
  List<Wallet> walletUser = [];
  User? user;
  House? house;
  Building? building;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      setState(() {
        isLoading = true;
        hasError = false;
      });

      // Initialize blocs
      _walletBloc = context.read<WalletBloc>();
      _authBloc = context.read<AuthBloc>();
      _houseBloc = context.read<HouseBloc>();
      _buildingBloc = context.read<BuildingBloc>();

      // Dispatch initial events
      context.read<ServiceBloc>().add(GetServicesEvent());
      _walletBloc.add(GetWallet());
      _authBloc.add(GetUserFromLocal());

      // Process data sequentially
      await _processAuthentication();
      await _processHouseAndBuilding();
      await _processWallet();
    } catch (e) {
      print('Initialization Error: $e');
      if (mounted) {
        setState(() {
          hasError = true;
        });
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _processAuthentication() async {
    try {
      final state = _authBloc.state;
      if (state is AuthenticationFromLocal) {
        user = state.user;
      } else {
        final completer = Completer<void>();
        late StreamSubscription<AuthState> subscription;

        subscription = _authBloc.stream.listen(
              (state) {
            if (state is AuthenticationFromLocal) {
              user = state.user;
              subscription.cancel();
              completer.complete();
            } else if (state is AuthenticationFailed) {
              subscription.cancel();
              completer.completeError(state.error);
            }
          },
          onError: (error) {
            subscription.cancel();
            completer.completeError(error);
          },
          cancelOnError: true,
        );

        await completer.future;
      }
    } catch (e) {
      print('Authentication Process Error: $e');
      rethrow;
    }
  }

  Future<void> _processHouseAndBuilding() async {
    if (user?.houseId == null) return;

    try {
      // Fetch House
      _houseBloc.add(GetHouseById(houseId: user!.houseId!));
      final houseState = await _waitForState<HouseState, HouseLoadedById>(
        _houseBloc,
            (state) => state is HouseLoadedById,
      );
      house = houseState.house;

      // Fetch Building if house has a building ID
      if (house?.buildingId != null) {
        _buildingBloc.add(GetBuilding(buildingId: house!.buildingId!));
        final buildingState = await _waitForState<BuildingState, OneBuildingLoaded>(
          _buildingBloc,
              (state) => state is OneBuildingLoaded,
        );
        building = buildingState.building;
      }
    } catch (e) {
      print('House and Building Process Error: $e');
      rethrow;
    }
  }

  Future<void> _processWallet() async {
    try {
      final state = _walletBloc.state;
      if (state is WalletLoaded) {
        walletUser = state.wallets;
      } else {
        final walletState = await _waitForState<WalletState, WalletLoaded>(
          _walletBloc,
              (state) => state is WalletLoaded,
        );
        walletUser = walletState.wallets;
      }
    } catch (e) {
      print('Wallet Process Error: $e');
      rethrow;
    }
  }

  // Generic method to wait for a specific state
  Future<T> _waitForState<S, T>(Bloc bloc, bool Function(S) predicate) {
    final completer = Completer<T>();
    late StreamSubscription subscription;

    subscription = bloc.stream.listen(
          (state) {
        if (predicate(state)) {
          subscription.cancel();
          completer.complete(state);
        }
      },
      onError: (error) {
        subscription.cancel();
        completer.completeError(error);
      },
      cancelOnError: true,
    );

    return completer.future;
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceBloc, ServiceState>(
      builder: (context, state) {
        if (state is ServiceLoadingState || isLoading) {
          return HomeScreenLoading();
        }

        if (hasError) {
          return _buildErrorScreen();
        }

        if (state is ServiceSuccessState) {
          return HomeScreenBody(
            servicesToFetch: state.services.items,
            walletUser: walletUser,
            user: user ?? User(),
            house: house ?? House(),
            building: building ?? Building(),
          );
        }

        return _buildErrorScreen();
      },
    );
  }

  Widget _buildErrorScreen() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 80, color: Colors.redAccent),
            SizedBox(height: 16),
            Text('Đã xảy ra lỗi!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black54)),
            SizedBox(height: 8),
            Text('Vui lòng thử lại sau.', style: TextStyle(fontSize: 16, color: Colors.black45)),
            SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => AppRouter.navigateToHome(),
              icon: Icon(Icons.refresh, color: Colors.black),
              label: Text('Thử lại', style: TextStyle(color: Colors.black)),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
