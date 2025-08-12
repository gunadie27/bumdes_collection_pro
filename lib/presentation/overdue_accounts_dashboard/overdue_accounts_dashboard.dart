import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/dashboard_header_widget.dart';
import './widgets/empty_state_widget.dart';
import './widgets/filter_chip_widget.dart';
import './widgets/group_card_widget.dart';
import './widgets/search_bar_widget.dart';
import './widgets/sort_bottom_sheet_widget.dart';

class OverdueAccountsDashboard extends StatefulWidget {
  const OverdueAccountsDashboard({Key? key}) : super(key: key);

  @override
  State<OverdueAccountsDashboard> createState() =>
      _OverdueAccountsDashboardState();
}

class _OverdueAccountsDashboardState extends State<OverdueAccountsDashboard> {
  int _currentTabIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _currentSortOption = 'amount_desc';
  List<String> _activeFilters = [];
  bool _isLoading = false;

  // Mock data for overdue accounts
  final List<Map<String, dynamic>> _overdueGroups = [
    {
      "id": 1,
      "village": "Desa Sukamaju",
      "groupLeader": "Budi Santoso",
      "memberCount": 15,
      "totalDebt": 25000000.0,
      "priority": "high",
      "lastVisit": "2025-01-15",
      "coordinates": {"lat": -6.2088, "lng": 106.8456},
    },
    {
      "id": 2,
      "village": "Desa Makmur Jaya",
      "groupLeader": "Siti Rahayu",
      "memberCount": 12,
      "totalDebt": 18500000.0,
      "priority": "medium",
      "lastVisit": "2025-01-10",
      "coordinates": {"lat": -6.1944, "lng": 106.8229},
    },
    {
      "id": 3,
      "village": "Desa Sejahtera",
      "groupLeader": "Ahmad Wijaya",
      "memberCount": 20,
      "totalDebt": 32000000.0,
      "priority": "high",
      "lastVisit": "2025-01-08",
      "coordinates": {"lat": -6.2297, "lng": 106.8467},
    },
    {
      "id": 4,
      "village": "Desa Harmoni",
      "groupLeader": "Dewi Lestari",
      "memberCount": 8,
      "totalDebt": 12000000.0,
      "priority": "low",
      "lastVisit": "2025-01-20",
      "coordinates": {"lat": -6.1751, "lng": 106.8650},
    },
    {
      "id": 5,
      "village": "Desa Bahagia",
      "groupLeader": "Rudi Hartono",
      "memberCount": 18,
      "totalDebt": 28500000.0,
      "priority": "medium",
      "lastVisit": "2025-01-12",
      "coordinates": {"lat": -6.2615, "lng": 106.7812},
    },
  ];

  final List<Map<String, String>> _availableFilters = [
    {"label": "Prioritas Tinggi", "value": "priority_high"},
    {"label": "Desa Sukamaju", "value": "village_sukamaju"},
    {"label": "> Rp 20 Juta", "value": "amount_high"},
    {"label": "Belum Dikunjungi", "value": "not_visited"},
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _refreshData() async {
    await _loadData();
  }

  double get _totalOverdueAmount {
    return _filteredGroups.fold(
        0.0, (sum, group) => sum + (group['totalDebt'] as double));
  }

  List<Map<String, dynamic>> get _filteredGroups {
    List<Map<String, dynamic>> filtered = List.from(_overdueGroups);

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((group) {
        final village = (group['village'] as String).toLowerCase();
        final leader = (group['groupLeader'] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();
        return village.contains(query) || leader.contains(query);
      }).toList();
    }

    // Apply active filters
    for (String filter in _activeFilters) {
      switch (filter) {
        case 'priority_high':
          filtered =
              filtered.where((group) => group['priority'] == 'high').toList();
          break;
        case 'village_sukamaju':
          filtered = filtered
              .where((group) => (group['village'] as String)
                  .toLowerCase()
                  .contains('sukamaju'))
              .toList();
          break;
        case 'amount_high':
          filtered = filtered
              .where((group) => (group['totalDebt'] as double) > 20000000)
              .toList();
          break;
        case 'not_visited':
          // Mock logic for not visited
          filtered = filtered
              .where((group) => DateTime.parse(group['lastVisit'])
                  .isBefore(DateTime.now().subtract(const Duration(days: 7))))
              .toList();
          break;
      }
    }

    // Apply sorting
    switch (_currentSortOption) {
      case 'amount_desc':
        filtered.sort((a, b) =>
            (b['totalDebt'] as double).compareTo(a['totalDebt'] as double));
        break;
      case 'amount_asc':
        filtered.sort((a, b) =>
            (a['totalDebt'] as double).compareTo(b['totalDebt'] as double));
        break;
      case 'date_desc':
        filtered.sort((a, b) => DateTime.parse(b['lastVisit'])
            .compareTo(DateTime.parse(a['lastVisit'])));
        break;
      case 'date_asc':
        filtered.sort((a, b) => DateTime.parse(a['lastVisit'])
            .compareTo(DateTime.parse(b['lastVisit'])));
        break;
      case 'priority_high':
        filtered.sort((a, b) {
          const priorityOrder = {'high': 3, 'medium': 2, 'low': 1};
          return (priorityOrder[b['priority']] ?? 0)
              .compareTo(priorityOrder[a['priority']] ?? 0);
        });
        break;
    }

    return filtered;
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _onFilterTap(String filterValue) {
    setState(() {
      if (_activeFilters.contains(filterValue)) {
        _activeFilters.remove(filterValue);
      } else {
        _activeFilters.add(filterValue);
      }
    });
  }

  void _removeFilter(String filterValue) {
    setState(() {
      _activeFilters.remove(filterValue);
    });
  }

  void _showSortBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SortBottomSheetWidget(
        currentSortOption: _currentSortOption,
        onSortChanged: (sortOption) {
          setState(() {
            _currentSortOption = sortOption;
          });
        },
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppTheme.radiusLarge),
            topRight: Radius.circular(AppTheme.radiusLarge),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(top: 2.h),
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(1.w),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filter Berdasarkan',
                    style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: _availableFilters.map((filter) {
                      final isActive = _activeFilters.contains(filter['value']);
                      return FilterChipWidget(
                        label: filter['label']!,
                        isSelected: isActive,
                        onTap: () => _onFilterTap(filter['value']!),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _activeFilters.clear();
                            });
                            Navigator.pop(context);
                          },
                          child: Text('Reset'),
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Terapkan'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onGroupTap(Map<String, dynamic> groupData) {
    Navigator.pushNamed(context, '/member-detail-screen', arguments: groupData);
  }

  void _onVisitNow(Map<String, dynamic> groupData) {
    Navigator.pushNamed(context, '/collection-form-screen',
        arguments: groupData);
  }

  void _onViewDetail(Map<String, dynamic> groupData) {
    Navigator.pushNamed(context, '/member-detail-screen', arguments: groupData);
  }

  void _onMakeAppointment(Map<String, dynamic> groupData) {
    // Show appointment dialog or navigate to appointment screen
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Buat Janji'),
        content: Text(
            'Fitur buat janji untuk ${groupData['village']} akan segera tersedia.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_currentTabIndex) {
      case 0:
        return _buildDashboardContent();
      case 1:
        return _buildCollectionsContent();
      case 2:
        return _buildProfileContent();
      default:
        return _buildDashboardContent();
    }
  }

  Widget _buildDashboardContent() {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: DashboardHeaderWidget(
              totalOverdueAmount: _totalOverdueAmount,
              onFilterTap: _showFilterBottomSheet,
              lastSyncTime: '22/07/2025 19:30',
            ),
          ),
          SliverToBoxAdapter(
            child: SearchBarWidget(
              controller: _searchController,
              onChanged: _onSearchChanged,
              onClear: () {
                setState(() {
                  _searchQuery = '';
                });
              },
            ),
          ),
          if (_activeFilters.isNotEmpty)
            SliverToBoxAdapter(
              child: Container(
                height: 6.h,
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _activeFilters.length,
                  itemBuilder: (context, index) {
                    final filterValue = _activeFilters[index];
                    final filterLabel = _availableFilters.firstWhere(
                        (f) => f['value'] == filterValue,
                        orElse: () => {'label': filterValue})['label']!;

                    return FilterChipWidget(
                      label: filterLabel,
                      isSelected: true,
                      onRemove: () => _removeFilter(filterValue),
                    );
                  },
                ),
              ),
            ),
          _isLoading
              ? SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.lightTheme.colorScheme.primary,
                    ),
                  ),
                )
              : _filteredGroups.isEmpty
                  ? SliverFillRemaining(
                      child: EmptyStateWidget(
                        onRefresh: _refreshData,
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final group = _filteredGroups[index];
                          return GroupCardWidget(
                            groupData: group,
                            onTap: () => _onGroupTap(group),
                            onVisitNow: () => _onVisitNow(group),
                            onViewDetail: () => _onViewDetail(group),
                            onMakeAppointment: () => _onMakeAppointment(group),
                          );
                        },
                        childCount: _filteredGroups.length,
                      ),
                    ),
          SliverToBoxAdapter(
            child: SizedBox(height: 10.h),
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionsContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'collections',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'Halaman Koleksi',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          SizedBox(height: 1.h),
          Text(
            'Fitur ini akan segera tersedia',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'person',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'Profil Pengguna',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          SizedBox(height: 1.h),
          Text(
            'Fitur ini akan segera tersedia',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: _buildTabContent(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTabIndex,
        onTap: (index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppTheme.lightTheme.colorScheme.surface,
        selectedItemColor: AppTheme.lightTheme.colorScheme.primary,
        unselectedItemColor: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        elevation: 8,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'dashboard',
              color: _currentTabIndex == 0
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'collections',
              color: _currentTabIndex == 1
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Collections',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              color: _currentTabIndex == 2
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
              size: 24,
            ),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: _currentTabIndex == 0
          ? FloatingActionButton(
              onPressed: _showSortBottomSheet,
              backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
              foregroundColor: AppTheme.lightTheme.colorScheme.onTertiary,
              child: CustomIconWidget(
                iconName: 'sort',
                color: AppTheme.lightTheme.colorScheme.onTertiary,
                size: 24,
              ),
            )
          : null,
    );
  }
}
