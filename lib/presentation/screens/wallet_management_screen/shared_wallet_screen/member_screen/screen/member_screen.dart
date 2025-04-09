import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/core/router/app_router.dart';
import 'package:home_clean/presentation/widgets/custom_app_bar.dart';
import 'package:home_clean/presentation/widgets/show_dialog.dart';

import '../../../../../../../domain/entities/user/user.dart';
import '../../../../../../../domain/entities/wallet/wallet.dart';
import '../../../../../../core/constant/colors.dart';
import '../../../../../blocs/auth/auth_bloc.dart';
import '../../../../../blocs/auth/auth_state.dart';
import '../../../../../blocs/user/user_bloc.dart';
import '../../../../../blocs/user/user_event.dart';
import '../../../../../blocs/user/user_state.dart';
import '../../../../../blocs/wallet/wallet_bloc.dart';
import '../../../../../blocs/wallet/wallet_event.dart';
import '../../../../../blocs/wallet/wallet_state.dart';
import 'member_screen_error.dart';
import 'member_screen_loading.dart';

class MembersScreen extends StatefulWidget {
  const MembersScreen({Key? key}) : super(key: key);

  @override
  State<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends State<MembersScreen> {
  List<Wallet> wallet = [];
  List<User> sortedMembers = [];
  Wallet sharedWallet = Wallet(id: '', type: 'Shared', balance: 0);
  bool isAdmin = false;
  User currentUser = User(id: '', fullName: '', phoneNumber: '');
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    setState(() {
      isLoading = true;
    });

    final authState = context.read<AuthBloc>().state;
    if (authState is AuthenticationFromLocal) {
      currentUser = authState.user;
    }

    final walletState = context.read<WalletBloc>().state;
    if (walletState is WalletLoaded) {
      wallet = walletState.wallets;
      sharedWallet = wallet.firstWhere((w) => w.type == 'Shared');
      isAdmin = sharedWallet.ownerId == currentUser.id;
    }
    _getMembers();
  }

  Future<void> _getMembers() async {
    setState(() {
      isLoading = true;
    });

    context.read<UserBloc>().add(
        GetUsersBySharedWalletEvent(walletId: sharedWallet.id ?? '')
    );
  }

  void _showDeleteMemberDialog(User user) {
    showDialog(
      context: context,
      builder: (context) {
        bool isLoading = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text('Xóa thành viên'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Bạn có chắc chắn muốn xóa ${user.fullName} khỏi ví chung?'),
                ],
              ),
              actions: [
                if (!isLoading)
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Hủy'),
                  ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: isLoading ? null : () async {
                    setState(() => isLoading = true);

                    final walletBloc = context.read<WalletBloc>();
                    walletBloc.add(DeleteWallet(
                        walletId: sharedWallet.id ?? '',
                        userId: user.id ?? ''
                    ));

                    await for (final state in walletBloc.stream) {
                      if (state is WalletDeleteSuccess) {
                        if (mounted) {
                          Navigator.pop(context);
                          _initData();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Đã xóa ${user.fullName} thành công'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                        break;
                      }
                      else if (state is WalletError) {
                        if (mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Lỗi: ${state.message}'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                        break;
                      }
                    }
                  },
                  child: isLoading
                      ? const Text('Đang xử lý...')
                      : const Text('Xóa'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddMemberDialog() {
    final TextEditingController phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserLoadedByPhone) {
            Navigator.pop(context); // Close the first dialog
            _showConfirmationDialog(state.user); // Show confirmation dialog
          }
        },
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Thêm thành viên mới'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  labelText: 'Số điện thoại',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                context
                    .read<UserBloc>()
                    .add(GetUserByPhoneNumberEvent(
             phoneController.text.trim(),
                ),);
              },
              child: const Text('Tìm thành viên'),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(User user) {
    showDialog(
      context: context,
      builder: (context) {
        // Thêm biến để theo dõi trạng thái loading
        bool isLoading = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text('Xác nhận mời thành viên'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isLoading)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 16),
                      child: CircularProgressIndicator(),
                    ),
                  Text('Bạn có muốn mời ${user.fullName} tham gia không?'),
                  const SizedBox(height: 8),
                  Text('Số điện thoại: ${user.phoneNumber}'),
                ],
              ),
              actions: [
                if (!isLoading)
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Hủy'),
                  ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: isLoading
                      ? null
                      : () async {
                    setState(() => isLoading = true);

                    // Gửi sự kiện mời thành viên
                    context.read<WalletBloc>().add(
                        InviteMember(
                            walletId: sharedWallet.id ?? '',
                            userId: user.id ?? ''
                        )
                    );

                    await for (final state in context.read<WalletBloc>().stream) {
                      if (state is WalletInviteMemberSuccess) {
                        Navigator.pop(context);
                        _initData();
                        break;
                      }
                      else if (state is WalletError) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Lỗi: $state'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        break;
                      }
                    }
                  },
                  child: Text(isLoading ? 'Đang xử lý...' : 'Mời'),
                ),
              ],
            );
          },
        );
      },
    );
  }


  void _showTransferOwnershipDialog(User user) {
    showDialog(
      context: context,
      builder: (context) {
        bool isLoading = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text('Chuyển quyền quản lý'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Bạn có chắc chắn muốn chuyển quyền quản lý cho ${user.fullName}?'),
                  const SizedBox(height: 8),
                  Text('Sau khi chuyển, bạn sẽ trở thành thành viên bình thường của ví chung.',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              actions: [
                if (!isLoading)
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Hủy'),
                  ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: isLoading ? null : () async {
                    setState(() => isLoading = true);

                    final changeOwnerBloc = context.read<ChangeOwnerBloc>();
                    changeOwnerBloc.add(
                      ChangeOwner(
                        walletId: sharedWallet.id ?? '',
                        userId: user.id ?? '',
                      ),
                    );

                    await for (final state in changeOwnerBloc.stream) {
                      if (state is WalletChangeOwnerSuccess) {
                        if (mounted) {
                          Navigator.pop(context);
                          _initData();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Đã chuyển quyền quản lý cho ${user.fullName} thành công'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                        break;
                      }
                      else if (state is WalletChangeOwnerError) {
                        if (mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Lỗi: ${state.message}'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                        break;
                      }
                    }
                  },
                  child: Text(isLoading ? 'Đang chuyển...' : 'Chuyển quyền'),
                ),
              ],
            );
          },
        );
      },
    );
  }


  void _showLeaveWalletDialog(User user) {
    showDialog(
      context: context,
      builder: (context) {
        bool isLoading = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text('Rời khỏi ví chung'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Bạn có chắc chắn muốn rời khỏi ví chung này?'),
                  const SizedBox(height: 8),
                  Text(
                    'Sau khi rời, bạn sẽ không thể thực hiện các giao dịch hoặc xem số dư của ví.',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              actions: [
                if (!isLoading)
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Hủy'),
                  ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: isLoading ? null : () async {
                    setState(() => isLoading = true);

                    final walletBloc = context.read<WalletBloc>();
                    walletBloc.add(DeleteWallet(
                        walletId: sharedWallet.id ?? '',
                        userId: user.id ?? ''
                    ));

                    await for (final state in walletBloc.stream) {
                      if (state is WalletDeleteSuccess) {
                        if (mounted) {
                          Navigator.pop(context);
                          AppRouter.navigateToHome();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Đã rời ví thành công'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                        break;
                      }
                      else if (state is WalletError) {
                        if (mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Lỗi: ${state.message}'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                        break;
                      }
                    }
                  },
                  child: Text(isLoading ? 'Đang rời...' : 'Rời ví'),
                ),
              ],
            );
          },
        );
      },
    );
  }


  void _showDeleteWallet(User user) {
    showDialog(
      context: context,
      builder: (context) {
        bool isLoading = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text('Giải tán ví chung'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Bạn có chắc chắn muốn giải tán ví chung này?',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(color: Colors.black87),
                      children: [
                        const TextSpan(
                          text: 'Khi giải tán ví này, ',
                        ),
                        TextSpan(
                          text: 'số dư còn lại sẽ được chuyển về bạn. ',
                          style: TextStyle(
                            color: Colors.blue.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const TextSpan(
                          text: 'Mọi giao dịch và thành viên sẽ bị xóa vĩnh viễn.',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.warning_outlined, color: Colors.red.shade700),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Thao tác này không thể hoàn tác',
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              actions: [
                if (!isLoading)
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Hủy'),
                  ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: isLoading ? null : () async {
                    setState(() => isLoading = true);

                    final disBloc = context.read<DissolutionBloc>();
                    disBloc.add(DissolutionWallet(
                      walletId: sharedWallet.id ?? ''));

                    await for (final state in disBloc.stream) {
                      if (state is WalletDissolutionSuccess) {
                        if (mounted) {
                          Navigator.pop(context);
                          AppRouter.navigateToHome();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Ví chung đã được giải tán'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                        break;
                      }
                      else if (state is WalletDissolutionError) {
                        if (mounted) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Lỗi: ${state.message}'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                        break;
                      }
                    }
                  },
                  child: Text(isLoading ? 'Đang giải tán...' : 'Giải tán ví'),
                ),
              ],
            );
          },
        );
      },
    );
  }

 @override
  Widget build(BuildContext context) {
   return BlocListener<UserBloc, UserState>(
       listener: (context, state) {
         if (state is UserWalletLoaded) {
           setState(() {
             sortedMembers = List.from(state.users.items);
             sortedMembers.sort((a, b) {
               if (a.id == sharedWallet.ownerId) return -1;
               if (b.id == sharedWallet.ownerId) return 1;
               return 0;
             });
             isLoading = false;
           });
         }
         else if (state is UserError) {
           setState(() {
             isLoading = false;
             sortedMembers = [];
           });
         }
       },
     child:  Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: CustomAppBar(
          title: 'Thành viên ví chung',
          onBackPressed: () => AppRouter.navigateToSharedWallet(),
        ),
        body: isLoading
            ? Center(
          child: const MemberScreenLoading(),
        )
            : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.people, size: 20, color: AppColors.primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        'Danh sách thành viên (${sortedMembers.length})',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  !isAdmin
                      ? TextButton(
                    onPressed: () {
                      _showLeaveWalletDialog(currentUser);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.red.withOpacity(0.2)),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.exit_to_app_outlined,
                          color: Colors.red,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          "Rời ví",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                      : TextButton(
                    onPressed: () {
                      _showDeleteWallet(currentUser);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.red.withOpacity(0.2)),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.exit_to_app_outlined,
                          color: Colors.red,
                          size: 18,
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          "Xóa ví",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  itemCount: sortedMembers.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 2),
                  itemBuilder: (context, index) {
                    final user = sortedMembers[index];
                    final bool isCurrentUser = user.id == currentUser.id;
                    final bool isWalletOwner = user.id == sharedWallet.ownerId;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        leading: CircleAvatar(
                          backgroundColor: isCurrentUser
                              ? AppColors.primaryColor
                              : Colors.grey.shade200,
                          child: Text(
                            user.fullName?.isNotEmpty == true
                                ? user.fullName![0].toUpperCase()
                                : '?',
                            style: TextStyle(
                              color: isCurrentUser
                                  ? Colors.white
                                  : Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Row(
                          children: [
                            Text(
                              user.fullName ?? 'Không có tên',
                              style: TextStyle(
                                fontWeight: isCurrentUser
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            if (isCurrentUser)
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'Bạn',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            if (isWalletOwner)
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.amber.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'Chủ ví',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.amber,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            user.phoneNumber ?? 'Không có số điện thoại',
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                        trailing: isAdmin && !isWalletOwner && !isCurrentUser
                            ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.person_remove_outlined,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                _showDeleteMemberDialog(user);
                              },
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.admin_panel_settings_outlined,
                                color: Colors.blue,
                              ),
                              onPressed: () {
                                // TODO: Implement transfer ownership logic
                                _showTransferOwnershipDialog(user);
                              },
                            ),
                          ],
                        )
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: isAdmin
            ? FloatingActionButton(
          onPressed: _showAddMemberDialog,
          backgroundColor: AppColors.primaryColor,
          child: const Icon(Icons.person_add),
        )
            : null,
     ),
    );
  }
}