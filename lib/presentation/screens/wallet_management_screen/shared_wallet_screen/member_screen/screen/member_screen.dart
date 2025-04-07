import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/core/constant/colors.dart';
import 'package:home_clean/core/router/app_router.dart';
import 'package:home_clean/presentation/blocs/auth/auth_event.dart';
import 'package:home_clean/presentation/blocs/wallet/wallet_event.dart';
import 'package:home_clean/presentation/widgets/custom_app_bar.dart';
import 'package:home_clean/presentation/widgets/show_dialog.dart';

import '../../../../../../../domain/entities/user/user.dart';
import '../../../../../../../domain/entities/wallet/wallet.dart';
import '../../../../../blocs/auth/auth_bloc.dart';
import '../../../../../blocs/auth/auth_state.dart';
import '../../../../../blocs/user/user_bloc.dart';
import '../../../../../blocs/user/user_event.dart';
import '../../../../../blocs/user/user_state.dart';
import '../../../../../blocs/wallet/wallet_bloc.dart';
import '../../../../../blocs/wallet/wallet_state.dart';
import '../widget/help_dialog.dart';
import 'member_screen_error.dart';
import 'member_screen_loading.dart';

class MembersScreen extends StatefulWidget {
  MembersScreen({Key? key}) : super(key: key);

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  List<Wallet> wallet = [];
  List<User> sortedMembers = [];
  Wallet sharedWallet = Wallet(id: '', type: 'Shared', balance: 0);
  bool isAdmin = false;
  User currentUser = User(id: '', fullName: '', phoneNumber: '');

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    final walletBloc = context.read<WalletBloc>();
    final authBloc = context.read<AuthBloc>();

    final state = walletBloc.state;
    if (state is! WalletLoaded) {
      walletBloc.add(GetWallet());

      await for (final walletState in walletBloc.stream) {
        if (walletState is WalletLoaded) {
          wallet = walletState.wallets;
          break;
        }
      }
    } else {
      wallet = state.wallets;
    }

    if (wallet.isNotEmpty) {
      sharedWallet = wallet.firstWhere(
        (w) => w.type == 'Shared',
        orElse: () => Wallet(id: '', type: 'Shared', balance: 0),
      );
    }

    authBloc.add(GetUserFromLocal());

    await for (final authState in authBloc.stream) {
      if (authState is AuthenticationFromLocal) {
        final owner = sharedWallet.ownerId;
        currentUser = authState.user;
        isAdmin = authState.user.id.toString() == owner.toString();
        break;
      }
    }

    if (sharedWallet.id != null && sharedWallet.id!.isNotEmpty) {
      context
          .read<UserBloc>()
          .add(GetUsersBySharedWalletEvent(walletId: sharedWallet.id ?? ''));
    }
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const HelpDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: CustomAppBar(
        title: 'Thành viên',
        onBackPressed: () => AppRouter.navigateToSharedWallet(),
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<WalletBloc, WalletState>(
            listener: (context, state) {
              if (state is WalletChangeOwnerSuccess ||
                  state is WalletDeleteSuccess) {
                if (sharedWallet.id != null && sharedWallet.id!.isNotEmpty) {
                  context.read<UserBloc>().add(GetUsersBySharedWalletEvent(
                      walletId: sharedWallet.id ?? ''));
                }
                AppRouter.navigateToSharedWallet();
              } else if (state is WalletError) {
                showCustomDialog(
                  context: context,
                  message: state.message,
                  type: DialogType.error,
                );
              }
            },
          ),
        ],
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return MemberScreenLoading();
            } else if (state is UserError) {
              return MemberScreenError();
            } else if (state is UserLoaded) {
              sortedMembers = List.from(state.users.items);
              sortedMembers.sort((a, b) {
                if (a.id == sharedWallet.ownerId) return -1;
                if (b.id == sharedWallet.ownerId) return 1;
                return 0;
              });
              return isAdmin ? _buildAdminView() : _buildMemberView();
            }

            // Trường hợp mặc định
            return const Center(child: Text('Không có dữ liệu'));
          },
        ),
      ),
    );
  }

  Widget _buildAdminView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Enhanced Summary Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryColor.withOpacity(0.9),
                  AppColors.primaryColor.withOpacity(1)
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 3,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.group_rounded,
                        color: Colors.white, size: 32),
                    const SizedBox(width: 12),
                    Text(
                      'Quản lý thành viên',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.7,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '${sortedMembers.length}',
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(0, 3),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'thành viên',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  height: 5,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Members Header with Invite Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Thành viên hiện tại',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.grey[800],
                    ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showInviteMemberModal(context),
                icon: Icon(
                  Icons.person_add,
                  color: Colors.white,
                  size: 20,
                ),
                label: Text(
                  'Mời thêm',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Enhanced Members List
          ...sortedMembers.map((member) {
            return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(
                    color: currentUser.id == member.id
                        ? Colors.blue[100]!
                        : sharedWallet.ownerId == member.id
                            ? Colors.orange[100]!
                            : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(15),
                    onTap: () {
                      // Optional: Add member details view
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Circular Avatar with Role Indicator
                          Stack(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundColor: currentUser.id == member.id
                                    ? Colors.blue[50]
                                    : sharedWallet.ownerId == member.id
                                        ? Colors.orange[50]
                                        : Colors.grey[200],
                                child: Text(
                                  member.fullName![0].toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: currentUser.id == member.id
                                        ? Colors.blue[800]
                                        : sharedWallet.ownerId == member.id
                                            ? Colors.orange[800]
                                            : Colors.grey[700],
                                  ),
                                ),
                              ),
                              // Role Badge
                              if (sharedWallet.ownerId == member.id ||
                                  currentUser.id == member.id)
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: sharedWallet.ownerId == member.id
                                          ? Colors.orange
                                          : Colors.blue,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      sharedWallet.ownerId == member.id
                                          ? Icons.admin_panel_settings
                                          : Icons.person,
                                      color: Colors.white,
                                      size: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      member.fullName!,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: currentUser.id == member.id
                                                ? Colors.blue[800]
                                                : sharedWallet.ownerId ==
                                                        member.id
                                                    ? Colors.orange[800]
                                                    : Colors.black87,
                                          ),
                                    ),
                                    if (sharedWallet.ownerId == member.id)
                                      Container(
                                        margin: const EdgeInsets.only(left: 8),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.orange.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: Colors.orange[300]!,
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          'Quản trị viên',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.orange[900],
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    if (currentUser.id == member.id)
                                      Container(
                                        margin: const EdgeInsets.only(left: 8),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.blue.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: Colors.blue[300]!,
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          'Bạn',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.blue[900],
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  member.phoneNumber ??
                                      'Số điện thoại chưa cập nhật',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Admin Actions Popup Menu
                          PopupMenuButton<String>(
                            icon: Icon(
                              Icons.more_vert,
                              color: Colors.grey[700],
                              size: 24,
                            ),
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            onSelected: (value) {
                              final walletBloc = context.read<WalletBloc>();

                              // Confirmation Dialog
                              showDialog(
                                context: context,
                                builder: (BuildContext dialogContext) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    title: Row(
                                      children: [
                                        Icon(
                                          value == 'make_admin'
                                              ? Icons.admin_panel_settings
                                              : Icons.person_remove,
                                          color: value == 'make_admin'
                                              ? AppColors.primaryColor
                                              : Colors.red,
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          value == 'make_admin'
                                              ? 'Đặt làm Quản trị viên'
                                              : 'Xóa thành viên',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: value == 'make_admin'
                                                ? AppColors.primaryColor
                                                : Colors.red[800],
                                          ),
                                        ),
                                      ],
                                    ),
                                    content: Text(
                                      value == 'make_admin'
                                          ? 'Bạn có chắc chắn muốn đặt ${member.fullName} làm quản trị viên của ví chung không?\n\nThao tác này sẽ chuyển toàn bộ quyền quản lý cho thành viên này.'
                                          : 'Bạn có chắc chắn muốn xóa ${member.fullName} khỏi ví chung không?\n\nThành viên này sẽ không còn quyền truy cập vào ví và các giao dịch.',
                                      style: TextStyle(
                                        color: Colors.black87,
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text(
                                          'Hủy',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.of(dialogContext).pop();
                                        },
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: value == 'make_admin'
                                              ? AppColors.primaryColor
                                              : Colors.red[700],
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: Text(
                                          value == 'make_admin'
                                              ? 'Đặt làm Admin'
                                              : 'Xóa thành viên',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        onPressed: () {
                                          // Đóng dialog
                                          Navigator.of(dialogContext).pop();

                                          // Thực hiện hành động
                                          if (value == 'make_admin') {
                                            walletBloc.add(ChangeOwner(
                                              walletId: sharedWallet.id ?? '',
                                              userId: member.id ?? '',
                                            ));
                                          } else if (value == 'remove') {
                                            walletBloc.add(DeleteWallet(
                                              walletId: sharedWallet.id ?? '',
                                              userId: member.id ?? '',
                                            ));
                                          }
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            itemBuilder: (context) => [
                              // Only show 'make admin' if the member is not already an admin
                              if (sharedWallet.ownerId != member.id)
                                PopupMenuItem(
                                  value: 'make_admin',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.admin_panel_settings,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Đặt làm Admin',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              if (currentUser.id != member.id)
                                PopupMenuItem(
                                  value: 'remove',
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.person_remove,
                                        color: Colors.red,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Xóa thành viên',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ));
          }),
        ],
      ),
    );
  }

  Widget _buildMemberView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Enhanced Summary Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryColor,
                  AppColors.primaryColor,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 3,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.group_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Thành viên ví chung',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.7,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '${sortedMembers.length}',
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            offset: const Offset(0, 3),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'thành viên',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  height: 5,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Members List Title with Subtle Decoration
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey[200]!, Colors.grey[100]!],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Danh sách thành viên',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[800],
                      ),
                ),
                Text(
                  'Tổng: ${sortedMembers.length}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Enhanced Members List
          ...sortedMembers.map((member) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: currentUser.id == member.id
                      ? Colors.blue[100]!
                      : sharedWallet.ownerId == member.id
                          ? Colors.orange[100]!
                          : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    // Optional: Add member details view
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Circular Avatar with Role Indicator
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: currentUser.id == member.id
                                  ? Colors.blue[50]
                                  : sharedWallet.ownerId == member.id
                                      ? Colors.orange[50]
                                      : Colors.grey[200],
                              child: Text(
                                member.fullName![0].toUpperCase(),
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: currentUser.id == member.id
                                      ? Colors.blue[800]
                                      : sharedWallet.ownerId == member.id
                                          ? Colors.orange[800]
                                          : Colors.grey[700],
                                ),
                              ),
                            ),
                            // Role Badge
                            if (sharedWallet.ownerId == member.id ||
                                currentUser.id == member.id)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: sharedWallet.ownerId == member.id
                                        ? Colors.orange
                                        : Colors.blue,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    sharedWallet.ownerId == member.id
                                        ? Icons.admin_panel_settings
                                        : Icons.person,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    member.fullName!,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: currentUser.id == member.id
                                              ? Colors.blue[800]
                                              : sharedWallet.ownerId ==
                                                      member.id
                                                  ? Colors.orange[800]
                                                  : Colors.black87,
                                        ),
                                  ),
                                  if (sharedWallet.ownerId == member.id)
                                    Container(
                                      margin: const EdgeInsets.only(left: 8),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.orange[300]!,
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        'Quản trị viên',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.orange[900],
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  if (currentUser.id == member.id)
                                    Container(
                                      margin: const EdgeInsets.only(left: 8),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.blue[300]!,
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        'Bạn',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.blue[900],
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                member.phoneNumber ??
                                    'Số điện thoại chưa cập nhật',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  void _showInviteMemberModal(BuildContext context) {
    final TextEditingController phoneController = TextEditingController();
    String? userId;
    String? phoneError; // Lưu lỗi nhập số điện thoại
    bool isLoading = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return MultiBlocListener(
              listeners: [
                BlocListener<UserBloc, UserState>(
                  listener: (context, state) {
                    setState(() {
                      isLoading = false;
                    });

                    if (state is WalletInviteMemberSuccess) {
                      Navigator.pop(context);
                    } else if (state is UserError) {
                      _showErrorDialog(context, 'Lỗi tìm kiếm người dùng',
                          'Không thể tìm thấy người dùng với số điện thoại này. Chi tiết lỗi: ${state.message}');
                    } else if (state is UserLoadedByPhone) {
                      userId = state.user.id; // Lưu userId để gọi sự kiện sau
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Xác nhận thêm thành viên'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Bạn có muốn thêm thành viên này:'),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor:
                                        AppColors.primaryColor.withOpacity(0.1),
                                    child: Text(
                                      state.user.fullName?.isNotEmpty == true
                                          ? state.user.fullName![0]
                                              .toUpperCase()
                                          : '?',
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          state.user.fullName ?? 'Không có tên',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          state.user.phoneNumber ?? '',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Hủy'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context); // Đóng pop-up xác nhận
                                if (userId != null) {
                                  setState(() {
                                    isLoading =
                                        true; // Bắt đầu loading khi gửi lời mời
                                  });
                                  context.read<WalletBloc>().add(InviteMember(
                                      walletId: sharedWallet.id ?? '',
                                      userId: userId!));
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Xác nhận'),
                            ),
                          ],
                        ),
                      );
                    } else if (state is UserLoading) {
                      setState(() {
                        isLoading = true;
                      });
                    }
                  },
                ),
                BlocListener<WalletBloc, WalletState>(
                  listener: (context, state) {
                    setState(() {
                      isLoading = false;
                    });

                    if (state is WalletInviteMemberSuccess) {
                      AppRouter.navigateToMember();
                    } else if (state is WalletError) {
                      _showErrorDialog(context, 'Lỗi khi thêm thành viên',
                          'Không thể thêm thành viên. ${state.message}');
                    } else if (state is WalletLoading) {
                      setState(() {
                        isLoading = true;
                      });
                    }
                  },
                ),
              ],
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 16,
                  right: 16,
                  top: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Mời thành viên mới',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'Số điện thoại',
                        hintText: 'Nhập số điện thoại',
                        prefixIcon: const Icon(Icons.phone_android),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Theme.of(context).primaryColor),
                        ),
                        suffixIcon: phoneController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    phoneController.clear();
                                    phoneError = null;
                                  });
                                },
                              )
                            : null,
                        errorText: phoneError,
                      ),
                      onChanged: (value) {
                        setState(() {
                          phoneError = null;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              if (phoneController.text.isNotEmpty) {
                                final phoneNumber = phoneController.text.trim();
                                final validPhoneRegex = RegExp(r'^0\d{8,9}$');
                                if (!validPhoneRegex.hasMatch(phoneNumber)) {
                                  setState(() {
                                    phoneError =
                                        'Số điện thoại không hợp lệ, vui lòng nhập 9 hoặc 10 số';
                                  });
                                  return;
                                }

                                setState(() {
                                  phoneError = null; // Xóa lỗi nếu hợp lệ
                                });

                                context.read<UserBloc>().add(
                                    GetUserByPhoneNumberEvent(phoneNumber));
                              } else {
                                setState(() {
                                  phoneError = 'Vui lòng nhập số điện thoại';
                                });
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        disabledBackgroundColor: Colors.grey,
                      ),
                      child: Text(
                        'Kiểm tra',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

// Hàm hiển thị dialog lỗi
  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
            ),
            SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
            const SizedBox(height: 12),
            const Text(
              'Vui lòng kiểm tra lại hoặc thử lại sau.',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void showSuccessDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.green),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
