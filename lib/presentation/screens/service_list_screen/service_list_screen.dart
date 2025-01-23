import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/core/app_text_styles.dart';
import 'package:home_clean/presentation/blocs/service_category/service_category_bloc.dart';
import 'package:home_clean/presentation/blocs/service_category/service_category_event.dart';
import 'package:home_clean/presentation/blocs/service_category/service_category_state.dart';
import 'package:home_clean/presentation/widgets/custom_app_bar.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/constant.dart';
import '../../../domain/entities/service.dart';

class ServiceListScreen extends StatefulWidget {
  const ServiceListScreen({Key? key}) : super(key: key);

  @override
  State<ServiceListScreen> createState() => _ServiceListScreenState();
}

class _ServiceListScreenState extends State<ServiceListScreen> {
  final TextEditingController _searchController = TextEditingController();
  Map<String, List<Service>> servicesByCategory = {};
  Map<String, List<Service>> filteredServicesByCategory = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    filteredServicesByCategory = servicesByCategory;

    _loadServices();
  }

  Future<void> _loadServices() async {
    final categoryBloc = context.read<ServiceCategoryBloc>();
    categoryBloc.add(GetServiceCategoriesEvent(
      search: _searchController.text,
      orderBy: '',
      page: 1,
      size: 5,
    ));

    final categoryState = await categoryBloc.stream.firstWhere(
      (state) => state is ServiceCategorySuccessState,
    );

    if (categoryState is ServiceCategorySuccessState) {
      for (var category in categoryState.serviceCategories) {
        if (!servicesByCategory.containsKey(category.name ?? '')) {
          servicesByCategory[category.name ?? ''] = [];
        }

        final serviceBloc = context.read<ServiceCategoryBloc>();
        serviceBloc.add(GetServiceByServiceCategoryEvent(
          serviceCategoryId: category.id ?? '',
          search: _searchController.text,
          orderBy: '',
          page: 1,
          size: 5,
        ));

        final serviceState = await serviceBloc.stream.firstWhere(
          (state) => state is ServiceByCategorySuccessState,
        );

        if (serviceState is ServiceByCategorySuccessState) {
          setState(() {
            servicesByCategory[category.name ?? ''] = serviceState.services;
          });
        }
      }
    }
    setState(() => isLoading = false);
  }

  void _filterServices(String query) {
    // Loại bỏ dấu từ chuỗi tìm kiếm
    final searchQuery = removeDiacritics(query).toLowerCase();

    if (query.isEmpty) {
      setState(() => filteredServicesByCategory = Map.from(servicesByCategory));
      return;
    }

    final filtered = <String, List<Service>>{};
    servicesByCategory.forEach((category, services) {
      final matchedServices = services
          .where((service) =>
              removeDiacritics(service.name?.toLowerCase() ?? '')
                  .contains(searchQuery))
          .toList();

      if (matchedServices.isNotEmpty) {
        filtered[category] = matchedServices;
      }
    });

    setState(() => filteredServicesByCategory = filtered);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(
        title: 'Services',
        onBackPressed: () => Navigator.of(context).pop(),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: isLoading
                ? _buildLoadingPlaceholder()
                : _buildServiceList(servicesByCategory),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: Offset(0, 2),
            blurRadius: 8,
          )
        ],
      ),
      child: TextField(
        controller: _searchController,
        style: GoogleFonts.poppins(),
        decoration: InputDecoration(
          hintText: 'Search services...',
          hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
          prefixIcon: Icon(Icons.search, color: Colors.grey[400], size: 22),
          filled: true,
          fillColor: Colors.grey[50],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onChanged: _filterServices,
      ),
    );
  }

  Widget _buildLoadingPlaceholder() {
    return ListView.builder(
      padding: EdgeInsets.only(top: 16),
      itemCount: 3,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 150,
                  height: 24,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12),
            Container(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 12),
                itemCount: 3,
                itemBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
          ],
        );
      },
    );
  }

  Widget _buildServiceList(Map<String, List<Service>> servicesByCategory) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() => isLoading = true);
        await _loadServices();
      },
      color: Color(0xFF1CAF7D),
      child: filteredServicesByCategory.isEmpty
          ? Center(
              child: Text(
                'No services found',
                style: AppTextStyles.body,
              ),
            )
          : ListView.builder(
              padding: EdgeInsets.only(top: 16),
              itemCount: filteredServicesByCategory.keys.length,
              itemBuilder: (context, index) {
                final categoryName =
                    filteredServicesByCategory.keys.elementAt(index);
                final services = filteredServicesByCategory[categoryName] ?? [];
                return Container(
                  // Wrap each item in a container
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: _buildCategorySection(categoryName, services),
                );
              },
            ),
    );
  }

  Widget _buildCategorySection(String categoryName, List<Service> services) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            categoryName,
            style: AppTextStyles.heading,
          ),
        ),
        SizedBox(height: 8),
        services.isEmpty
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Coming Soon',
                  style: AppTextStyles.headingGrey,
                ),
              )
            : Container(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    final service = services[index];
                    return _buildServiceCard(service);
                  },
                ),
              ),
        SizedBox(height: 16),
      ],
    );
  }

  Widget _buildServiceCard(Service service) {
    final iconColor = Constant.iconColorMapping[service.code?.toLowerCase()] ??
        Color(0xFF1CAF7D);

    // Split the service name and handle empty cases
    List<String> words = service.name!.split(' ');
    String? firstLine =
        words.length > 2 ? words.sublist(0, 2).join(' ') : service.name;
    String secondLine = words.length > 2 ? words.sublist(2).join(' ') : '';

    return Container(
      width: 130,
      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center the children horizontally
            children: [
              // Icon with background
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Constant.iconMapping[service.code?.toLowerCase()] ??
                      Icons.help,
                  color: iconColor,
                  size: 32,
                ),
              ),
              SizedBox(height: 12),
              // First line of the service name
              Text(
                firstLine!,
                style: AppTextStyles.body,
                textAlign: TextAlign.center,
              ),
              if (secondLine.isNotEmpty)
                Text(
                  secondLine,
                  style: AppTextStyles.body,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
