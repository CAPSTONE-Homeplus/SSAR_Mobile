import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/core/router/app_router.dart';
import 'package:home_clean/presentation/blocs/building/building_state.dart';
import 'package:home_clean/presentation/blocs/house/house_bloc.dart';
import 'package:home_clean/presentation/blocs/house/house_event.dart';


import '../../../domain/entities/building/building.dart';
import '../../../domain/entities/house/house.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/building/building_bloc.dart';
import '../../blocs/building/building_event.dart';
import '../register/components/building_field.dart';
import '../register/components/house_field.dart';

class AddressOptionScreen extends StatelessWidget {
  const AddressOptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      body: AddressOptionView(),
    );
  }
}

class AddressOptionView extends StatelessWidget {
  const AddressOptionView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is RegisterSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Registration successful!'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop(); // Navigate back to login
          } else if (state is RegisterFailed) {
            AppRouter.navigateToLogin();
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 32),
                    const RegisterFormContent(),
                  ],
                ),
              ),
            ),
          );
        }
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Text(
          'Đăng ký tài khoản',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1CAF7D),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Hãy điền thông tin của bạn để tạo tài khoản',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

class RegisterFormContent extends StatefulWidget {
  const RegisterFormContent({super.key});

  @override
  State<RegisterFormContent> createState() => _RegisterFormContentState();
}

class _RegisterFormContentState extends State<RegisterFormContent> {
  final _formKey = GlobalKey<FormState>();
  final _houseCodeController = TextEditingController();
  var _buildingCodeController = TextEditingController();
  late List<House> availableHomes = [];
  late List<Building> availableBuildings = [];
  late BuildingBloc _buildingBloc;
  bool isLoading = true;
  late Building selectedBuildingObj = Building(id: '', code: '', name: '');
  late House selectedHouseObj = House(id: '', code: '', buildingId: '');

  @override
  void dispose() {
    _houseCodeController.dispose();
    _buildingCodeController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        setState(() {
          isLoading = true;
        });
        _buildingBloc = context.read<BuildingBloc>();
        _buildingBloc.add(GetBuildings(search: '', orderBy: ''));
        final buildingComplete = _processBuildings();
        await Future.wait([
          buildingComplete
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

  void _fetchHouseList(BuildContext context, String buildingName) {
    final building = availableBuildings.firstWhere(
          (b) => b.name == buildingName,
      orElse: () => Building(id: "", name: ""),
    );

    if (building.id != "") {
      context.read<HouseBloc>().add(GetHouseByBuilding(
          buildingId: building.id ?? ""
      ));

    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Không tìm thấy tòa nhà: $buildingName")),
      );
    }
  }


  Future<void> _processBuildings() async {
    await for (final state in _buildingBloc.stream) {
      if (state is BuildingLoaded && mounted) {
        setState(() {
          availableBuildings = state.buildings.items;
        });
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 16),
          BuildingFieldWidget(
            availableBuildings: availableBuildings,
            onBuildingSelected: (selectedBuilding) {
              setState(() {
                selectedBuildingObj = selectedBuilding;
                _buildingCodeController.text = selectedBuilding.name!;
                _houseCodeController.clear();
                selectedHouseObj = House(id: '', code: '', buildingId: '');
              });
              _fetchHouseList(context, selectedBuilding.name ?? '');
            },
          ),

          const SizedBox(height: 16),
          HouseCodeFieldWidget(
            houseCodeController: _houseCodeController,
            houseBloc: context.read<HouseBloc>(),
            onHouseSelected: (selectedHouse) {
              setState(() {
                selectedHouseObj = selectedHouse;
              });
            },
          ),
        ],
      ),
    );
  }
}