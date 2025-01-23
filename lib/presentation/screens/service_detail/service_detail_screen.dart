import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/domain/entities/option.dart';
import 'package:home_clean/domain/entities/service.dart';
import 'package:home_clean/domain/entities/service_activity.dart';
import 'package:home_clean/presentation/blocs/option/option_event.dart';
import 'package:home_clean/presentation/blocs/option/option_state.dart';
import 'package:home_clean/presentation/blocs/service_activity/service_activity_bloc.dart';
import 'package:home_clean/presentation/blocs/service_activity/service_activity_event.dart';
import 'package:home_clean/presentation/blocs/service_activity/service_activity_state.dart';
import 'package:shimmer/shimmer.dart';

import '../../blocs/option/option_bloc.dart';

class ServiceDetailScreen extends StatefulWidget {
  final Service service;

  const ServiceDetailScreen({Key? key, required this.service})
      : super(key: key);

  @override
  _ServiceDetailScreenState createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  List<String> _selectedOptions = [];
  List<ServiceActivity> _serviceActivities = [];
  List<Option> _options = [];
  late ServiceActivityBloc _serviceActivityBloc;
  late OptionBloc _optionBloc;
  bool isLoading = true;
  bool _isPremiumToolsEnabled = false;

  final List<Map<String, String>> _standardTools = [
    {'name': 'Basic Vacuum Cleaner', 'price': '50,000 VND'},
  ];

  final List<Map<String, String>> _premiumTools = [
    {'name': 'Vacuum Cleaner', 'price': '100,000 VND'},
    {'name': 'Steam Cleaner', 'price': '120,000 VND'},
  ];

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        _serviceActivityBloc = context.read<ServiceActivityBloc>();
        _optionBloc = context.read<OptionBloc>();

        _serviceActivityBloc.add(GetServiceActivitiesByServiceIdEvent(
            serviceId: widget.service.id ?? ''));

        _optionBloc.add(GetOptionsEvent(serviceId: widget.service.id ?? ''));
        Future.delayed(Duration(seconds: 1));
        // Listen to bloc states to update loading
        _serviceActivityBloc.stream.listen((state) {
          if (mounted && state is ServiceActivitySuccessState) {
            setState(() {
              _serviceActivities = state.serviceActivities;
              isLoading = false;
            });
          }
        });
        Future.delayed(Duration(seconds: 1));
        _optionBloc.stream.listen((state) {
          if (mounted && state is OptionSuccessState) {
            setState(() {
              _options = state.options;
              isLoading = false;
            });
          }
        });
      } catch (e) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  // Future<void> _initServiceActivities() async {
  //   _serviceActivityBloc = context.read<ServiceActivityBloc>();
  //   _serviceActivityBloc.add(GetServiceActivitiesByServiceIdEvent(
  //       serviceId: widget.service.id ?? ''));
  //   Future.delayed(Duration(seconds: 3));
  //   _serviceActivityBloc.stream.listen((state) {
  //     if (mounted && state is ServiceActivitySuccessState) {
  //       setState(() {
  //         _serviceActivities = state.serviceActivities;
  //       });
  //     }
  //   });
  // }

  // Future<void> _initServiceOptions() async {
  //   _optionBloc = context.read<OptionBloc>();
  //   _optionBloc.add(GetOptionsEvent(serviceId: widget.service.id ?? ''));
  //   Future.delayed(Duration(seconds: 3));
  //   _optionBloc.stream.listen((state) {
  //     if (mounted && state is OptionSuccessState) {
  //       setState(() {
  //         _options = state.options;
  //       });
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.service.name ?? '',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: isLoading
          ? _loadingPlaceholder()
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPremiumServiceOption(),
                  _buildAdditionalOptionsSection(),
                  _buildJobDetailsSection(),
                ],
              ),
            ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _loadingPlaceholder() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 150,
                  height: 24,
                  color: Colors.white,
                ),
                SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  height: 60,
                  color: Colors.white,
                ),
                SizedBox(height: 20),
                Container(
                  width: 200,
                  height: 24,
                  color: Colors.white,
                ),
                SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  height: 100,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumServiceOption() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Chọn công cụ nâng cao',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Switch(
                value: _isPremiumToolsEnabled,
                onChanged: (bool value) {
                  setState(() {
                    _isPremiumToolsEnabled = value;
                  });
                },
                activeColor: Color(0xFF1CAF7D),
              ),
            ],
          ),
          SizedBox(height: 12),
          GestureDetector(
            onTap: _showToolsList,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey, width: 1),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Danh sách dụng cụ',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showToolsList() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        final List<Map<String, String>> toolsToShow = _isPremiumToolsEnabled
            ? [..._standardTools, ..._premiumTools]
            : _standardTools;

        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _isPremiumToolsEnabled ? 'Premium Tools' : 'Standard Tools',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 12),
              ...toolsToShow.map((tool) {
                return ListTile(
                  title: Text(
                    tool['name']!,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    tool['price']!,
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                    ),
                  ),
                  leading: Icon(
                    Icons.cleaning_services_outlined,
                    color: _isPremiumToolsEnabled
                        ? Color(0xFF1CAF7D)
                        : Colors.grey,
                  ),
                );
              }).toList(),
              SizedBox(height: 12),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF1CAF7D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Close',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAdditionalOptionsSection() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tùy chọn thêm',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          _buildOption(),
        ],
      ),
    );
  }

  Widget _buildOption() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: _options.map((option) {
          return CheckboxListTile(
            title: Text(
              option.name ?? 'Unnamed Option',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            subtitle: Text(
              option.price != null ? '+${option.price} VND' : '',
              style: GoogleFonts.poppins(
                color: Colors.grey,
              ),
            ),
            value: _selectedOptions.contains(option.id),
            onChanged: (value) {
              setState(() {
                if (value!) {
                  _selectedOptions.add(option.id ?? '');
                } else {
                  _selectedOptions.remove(option.id);
                }
              });
            },
          );
        }).toList(),
      ),
    );
  }

  Widget _buildJobDetailsSection() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chi tiết công việc',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          _serviceActivities.isEmpty
              ? Center(
                  child: Text(
                    'Không có hoạt động nào',
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _serviceActivities.length,
                  itemBuilder: (context, index) {
                    final activity = _serviceActivities[index];
                    return Container(
                      margin: EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.check_circle_outline,
                          color: Color(0xFF1CAF7D),
                        ),
                        title: Text(
                          activity.name ?? 'Unnamed Activity',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        trailing: Icon(
                          Icons.info_outline,
                          color: Colors.grey,
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total: 200,000 VND',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF1CAF7D),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Book Now',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
