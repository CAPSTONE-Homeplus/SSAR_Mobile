import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home_clean/core/constant/colors.dart';
import 'package:home_clean/core/router/app_router.dart';
import 'package:home_clean/presentation/blocs/wallet/wallet_event.dart';
import 'package:home_clean/presentation/widgets/custom_app_bar.dart';

import '../../../../../../../domain/entities/user/user.dart';
import '../../../../../../../domain/entities/wallet/wallet.dart';
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
  late Wallet sharedWallet;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  Future<void> _initData() async {
    final walletBloc = context.read<WalletBloc>();
    final state = walletBloc.state;

    if (state is WalletLoaded) {
      wallet = state.wallets;
    } else {
      walletBloc.add(GetWallet());
      return;
    }

    if (wallet.isNotEmpty) {
      sharedWallet = wallet.firstWhere(
            (w) => w.type == 'Shared',
        orElse: () => Wallet(id: '', type: 'Shared', balance: 0),
      );
    } else {
      sharedWallet = Wallet(id: '', type: 'Shared', balance: 0);
    }

    if (sharedWallet.id != null) {
      context.read<UserBloc>().add(GetUsersBySharedWalletEvent(walletId: sharedWallet.id ?? ''));
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
      appBar: CustomAppBar(title: 'Thành viên',
          onHelpPressed: () => _showHelpDialog(context),
          onBackPressed: () => AppRouter.navigateToSharedWallet()),
      body: MultiBlocListener(listeners: [
        BlocListener<WalletBloc, WalletState>(
          listener: (context, state) {
            if (state is WalletChangeOwnerSuccess || state is WalletDeleteSuccess) {
              if (sharedWallet.id != null && sharedWallet.id!.isNotEmpty) {
                context.read<UserBloc>().add(GetUsersBySharedWalletEvent(walletId: sharedWallet.id ?? ''));
              }

              String message = state is WalletChangeOwnerSuccess
                  ? 'Đã thay đổi Admin thành công'
                  : 'Đã xóa thành viên thành công';

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            } else if (state is WalletError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Lỗi: ${state.message}'),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
        ),
      ],
        child: BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return MemberScreenLoading();
        } else if (state is UserLoaded) {
          sortedMembers  = List.from(state.users.items);
          sortedMembers.sort((a, b) {
            if (a.id == sharedWallet.ownerId) return -1;
            if (b.id == sharedWallet.ownerId) return 1;
            return 0;
          });

        } else if (state is UserError) {
          return MemberScreenError();
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primaryColor.withOpacity(0.9), AppColors.primaryColor],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.people, color: Colors.white, size: 24),
                        const SizedBox(width: 8),
                        Text(
                          'Tổng thành viên',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${sortedMembers.length}',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 40,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.2),
                            offset: const Offset(0, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 4,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Active members heading
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Thành viên hiện tại',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      _showInviteMemberModal(context);
                    },
                    icon: Icon(Icons.person_add, size: 16, color: AppColors.primaryColor),
                    label: Text(
                      'Mời thêm',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Members list
              ...sortedMembers.map((member) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.blue.withOpacity(0.2),
                          child: Text(
                            member.fullName![0].toUpperCase(),
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    member.fullName!,
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (sharedWallet.ownerId == member.id)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        'Quản trị viên',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.green,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                member.phoneNumber!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuButton<String>(
                          icon: Icon(Icons.more_vert, color: Colors.grey[700]),
                          onSelected: (value) {
                            final walletBloc = context.read<WalletBloc>();

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

                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'make_admin',
                              child: Row(
                                children: [
                                  Icon(Icons.admin_panel_settings, color: Theme.of(context).primaryColor),
                                  const SizedBox(width: 8),
                                  const Text('Đặt làm Admin', style: TextStyle(fontSize: 14)),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'remove',
                              child: Row(
                                children: [
                                  const Icon(Icons.person_remove, color: Colors.red),
                                  const SizedBox(width: 8),
                                  const Text('Xóa thành viên', style: TextStyle(fontSize: 14)),
                                ],
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        );
      },
      ),),
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
                      _showErrorDialog(
                          context,
                          'Lỗi tìm kiếm người dùng',
                          'Không thể tìm thấy người dùng với số điện thoại này. Chi tiết lỗi: ${state.message}'
                      );
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
                                    backgroundColor: AppColors.primaryColor.withOpacity(0.1),
                                    child: Text(
                                      state.user.fullName?.isNotEmpty == true
                                          ? state.user.fullName![0].toUpperCase()
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
                                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                    isLoading = true; // Bắt đầu loading khi gửi lời mời
                                  });
                                  context.read<WalletBloc>().add(InviteMember(
                                      walletId: sharedWallet.id ?? '',
                                      userId: userId!
                                  ));
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
                      showSuccessDialog(context,
                          'Thành công',
                          'Đã gửi lời mời thành công');
                    } else if (state is WalletError) {
                      _showErrorDialog(
                          context,
                          'Lỗi khi thêm thành viên',
                          'Không thể thêm thành viên. ${state.message}'
                      );
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
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
                          borderSide: BorderSide(color: Theme.of(context).primaryColor),
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
                              phoneError = 'Số điện thoại không hợp lệ, vui lòng nhập 9 hoặc 10 số';
                            });
                            return;
                          }

                          setState(() {
                            phoneError = null; // Xóa lỗi nếu hợp lệ
                          });

                          context.read<UserBloc>().add(GetUserByPhoneNumberEvent(phoneNumber));
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
                      child:
                      Text(
                        'Kiểm tra',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
