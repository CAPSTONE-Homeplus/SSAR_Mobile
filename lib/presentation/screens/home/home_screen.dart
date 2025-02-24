import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/core/router/app_router.dart';
import 'package:home_clean/domain/entities/wallet/wallet.dart';
import 'package:home_clean/presentation/blocs/auth/auth_event.dart';
import 'package:home_clean/presentation/blocs/service/service_bloc.dart';
import 'package:home_clean/presentation/blocs/wallet/wallet_bloc.dart';
import 'package:home_clean/presentation/blocs/wallet/wallet_state.dart';
import 'package:home_clean/presentation/screens/home/components/home_screen_body.dart';
import 'package:home_clean/presentation/screens/home/components/home_screen_loading.dart';

import '../../../core/constant/size_config.dart';
import '../../../domain/entities/user/user.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/wallet/wallet_event.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late WalletBloc _walletBloc;
  late AuthBloc _authBloc;
  List<Wallet> walletUser = [];
  User? user;

  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    context
        .read<ServiceBloc>()
        .add(GetServicesEvent(search: '', orderBy: '', page: 1, size: 8));
    _init();
  }

  void _init() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        setState(() {
          isLoading = true;
        });
        _walletBloc = context.read<WalletBloc>();
        _authBloc = context.read<AuthBloc>();
        _walletBloc.add(GetWallet());
        _authBloc.add(GetUserFromLocal(user: user ?? User()));
        final walletComplete = _processWallet();
        final userComplete = _processUser();
        await Future.wait([
          walletComplete,
          userComplete,
        ]);
        setState(() {
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  Future<void> _processWallet() async {
    await for (final state in _walletBloc.stream) {
      if (state is WalletLoaded && mounted) {
        print('Wallet loaded${state.wallets}');
        setState(() {
          walletUser = state.wallets;
        });
        break;
      }
    }
  }

  Future<void> _processUser() async {
    await for (final state in _authBloc.stream) {
      if (state is AuthenticationFromLocal && mounted) {
        setState(() {
          user = state.user;
        });
        break;
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BlocBuilder<ServiceBloc, ServiceState>(
      builder: (context, state) {
        if (state is ServiceLoadingState|| isLoading) {
          return HomeScreenLoading();
        } else if (state is ServiceSuccessState) {
          final services = state.services;
          return HomeScreenBody(servicesToFetch: services,
              walletUser: walletUser, user: user ?? User());
        } else {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 80,
                    color: Colors.redAccent,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Đã xảy ra lỗi!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Vui lòng thử lại sau.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black45,
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      AppRouter.navigateToHome();
                    },
                    icon: Icon(Icons.refresh, color: Colors.black),
                    label:
                        Text('Thử lại', style: TextStyle(color: Colors.black)),
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
