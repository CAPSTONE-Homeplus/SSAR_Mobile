import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/app_router.dart';
import 'package:home_clean/domain/entities/wallet/wallet.dart';
import 'package:home_clean/presentation/blocs/service/service_bloc.dart';
import 'package:home_clean/presentation/blocs/wallet/wallet_bloc.dart';
import 'package:home_clean/presentation/blocs/wallet/wallet_state.dart';
import 'package:home_clean/presentation/screens/home/components/home_screen_body.dart';
import 'package:home_clean/presentation/screens/home/components/home_screen_loading.dart';

import '../../../core/size_config.dart';
import '../../blocs/wallet/wallet_event.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late WalletBloc _walletBloc;
  late List<Wallet> walletUser = [];
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

        // Init blocs
        _walletBloc = context.read<WalletBloc>();


        // Fetch service events
        _walletBloc.add(GetWallet());


        // Process events
        final walletComplete = _processWallet();


        // Wait for all events to complete
        await Future.wait([
          walletComplete,
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

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return BlocBuilder<ServiceBloc, ServiceState>(
      builder: (context, state) {
        if (state is ServiceLoadingState || isLoading) {
          return HomeScreenLoading();
        } else if (state is ServiceSuccessState) {
          final services = state.services;
          return HomeScreenBody(servicesToFetch: services, walletUser: walletUser);
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
