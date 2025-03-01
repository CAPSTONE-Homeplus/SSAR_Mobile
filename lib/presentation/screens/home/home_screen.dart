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

import '../../../core/constant/size_config.dart';
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

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      setState(() => isLoading = true);

      _walletBloc = context.read<WalletBloc>();
      _authBloc = context.read<AuthBloc>();
      _houseBloc = context.read<HouseBloc>();
      _buildingBloc = context.read<BuildingBloc>();
      context.read<ServiceBloc>().add(GetServicesEvent());

      _walletBloc.add(GetWallet());
      _authBloc.add(GetUserFromLocal());

      await _processUser();
      if (user?.houseId != null) {
        _houseBloc.add(GetHouseById(houseId: user!.houseId!));
        await _processHouse();
      }

      if (house?.buildingId != null) {
        _buildingBloc.add(GetBuilding(buildingId: house!.buildingId!));
        await _processBuilding();
      }

      await _processWallet();
    } catch (e) {
      print('Error: $e');
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _processWallet() async {
    final state = _walletBloc.state;
    if (state is WalletLoaded) {
      walletUser = state.wallets;
      return;
    }

    await for (final newState in _walletBloc.stream) {
      if (newState is WalletLoaded && mounted) {
        walletUser = newState.wallets;
        break;
      }
    }
  }

  Future<void> _processUser() async {
    final state = _authBloc.state;
    if (state is AuthenticationFromLocal) {
      user = state.user;
      return;
    }

    await for (final newState in _authBloc.stream) {
      if (newState is AuthenticationFromLocal && mounted) {
        user = newState.user;
        break;
      }
    }
  }

  Future<void> _processHouse() async {
    final state = _houseBloc.state;
    if (state is HouseLoadedById) {
      house = state.house;
      return;
    }

    await for (final newState in _houseBloc.stream) {
      if (newState is HouseLoadedById && mounted) {
        house = newState.house;
        break;
      }
    }
  }


  Future<void> _processBuilding() async {
    final state = _buildingBloc.state;
    if (state is OneBuildingLoaded) {
      building = state.building;
      return;
    }

    await for (final newState in _buildingBloc.stream) {
      if (newState is OneBuildingLoaded && mounted) {
        building = newState.building;
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BlocBuilder<ServiceBloc, ServiceState>(
      builder: (context, state) {
        if (state is ServiceLoadingState || isLoading) {
          return HomeScreenLoading();
        } else if (state is ServiceSuccessState && !isLoading) {
          return HomeScreenBody(
            servicesToFetch: state.services.items,
            walletUser: walletUser,
            user: user ?? User(),
            house: house ?? House(),
            building: building ?? Building(),
          );
        } else {
          return _buildErrorScreen();
        }
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
