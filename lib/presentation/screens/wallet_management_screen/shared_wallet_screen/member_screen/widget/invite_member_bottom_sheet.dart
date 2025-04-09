import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/constant/colors.dart';
import '../../../../../../domain/entities/user/user.dart';
import '../../../../../blocs/user/user_bloc.dart';
import '../../../../../blocs/user/user_event.dart';
import '../../../../../blocs/user/user_state.dart';
import '../../../../../blocs/wallet/wallet_bloc.dart';
import '../../../../../blocs/wallet/wallet_event.dart';
import '../../../../../blocs/wallet/wallet_state.dart';

class InviteMemberBottomSheet extends StatefulWidget {
  final String sharedWalletId;

  const InviteMemberBottomSheet({
    Key? key,
    required this.sharedWalletId,
  }) : super(key: key);

  @override
  _InviteMemberBottomSheetState createState() => _InviteMemberBottomSheetState();
}

class _InviteMemberBottomSheetState extends State<InviteMemberBottomSheet> {
  final TextEditingController _phoneController = TextEditingController();
  String? _phoneError;
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _showErrorDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.red),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  bool _validatePhoneNumber(String phoneNumber) {
    final validPhoneRegex = RegExp(r'^0\d{8,9}$');
    return validPhoneRegex.hasMatch(phoneNumber);
  }

  void _handleUserSearch(BuildContext context) {
    final phoneNumber = _phoneController.text.trim();

    if (phoneNumber.isEmpty) {
      setState(() {
        _phoneError = 'Vui lòng nhập số điện thoại';
      });
      return;
    }

    if (!_validatePhoneNumber(phoneNumber)) {
      setState(() {
        _phoneError = 'Số điện thoại không hợp lệ, vui lòng nhập 9 hoặc 10 số';
      });
      return;
    }

    // Clear any previous errors
    setState(() {
      _phoneError = null;
      _isLoading = true;
    });

    // Trigger user search
    context.read<UserBloc>().add(GetUserByPhoneNumberEvent(phoneNumber));
  }

  void _inviteMember(BuildContext context, User user) {
    context.read<WalletBloc>().add(InviteMember(
      walletId: widget.sharedWalletId,
      userId: user.id ?? '',
    ));
  }

  Widget _buildUserConfirmationDialog(User user) {
    return AlertDialog(
      title: const Text('Xác nhận thêm thành viên'),
      content: _buildUserDetails(user),
      actions: _buildConfirmationDialogActions(user),
    );
  }

  Widget _buildUserDetails(User user) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Bạn có muốn thêm thành viên này:'),
        const SizedBox(height: 8),
        _buildUserProfileRow(user),
      ],
    );
  }

  Widget _buildUserProfileRow(User user) {
    return Row(
      children: [
        _buildUserAvatar(user),
        const SizedBox(width: 8),
        Expanded(child: _buildUserInfo(user)),
      ],
    );
  }

  Widget _buildUserAvatar(User user) {
    return CircleAvatar(
      backgroundColor: AppColors.primaryColor.withOpacity(0.1),
      child: Text(
        user.fullName?.isNotEmpty == true
            ? user.fullName![0].toUpperCase()
            : '?',
        style: TextStyle(
          color: AppColors.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildUserInfo(User user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          user.fullName ?? 'Không có tên',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          user.phoneNumber ?? '',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildConfirmationDialogActions(User user) {
    return [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Hủy'),
      ),
      ElevatedButton(
        onPressed: () {
          Navigator.pop(context); // Đóng pop-up xác nhận
          _inviteMember(context, user);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
        ),
        child: const Text('Xác nhận'),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UserBloc, UserState>(
          listener: (context, state) {
            setState(() {
              _isLoading = false;
            });

            if (state is UserError) {
              _showErrorDialog(
                context,
                'Lỗi tìm kiếm người dùng',
                'Không thể tìm thấy người dùng với số điện thoại này. Chi tiết lỗi: ${state.message}',
              );
            } else if (state is UserLoadedByPhone) {
              showDialog(
                context: context,
                builder: (context) => _buildUserConfirmationDialog(state.user),
              );
            }
          },
        ),
        BlocListener<WalletBloc, WalletState>(
          listener: (context, state) {
            if (state is WalletInviteMemberSuccess) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Đã mời thành viên thành công'),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is WalletError) {
              _showErrorDialog(
                context,
                'Lỗi mời thành viên',
                'Không thể mời thành viên. Chi tiết lỗi: ${state.message}',
              );
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
            _buildBottomSheetHeader(),
            const SizedBox(height: 16),
            _buildPhoneNumberTextField(),
            const SizedBox(height: 24),
            _buildSearchButton(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheetHeader() {
    return Row(
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
    );
  }

  Widget _buildPhoneNumberTextField() {
    return TextField(
      controller: _phoneController,
      keyboardType: TextInputType.phone,
      decoration: _buildPhoneInputDecoration(),
      onChanged: (_) {
        setState(() {
          _phoneError = null;
        });
      },
    );
  }

  InputDecoration _buildPhoneInputDecoration() {
    return InputDecoration(
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
      suffixIcon: _phoneController.text.isNotEmpty
          ? IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          setState(() {
            _phoneController.clear();
            _phoneError = null;
          });
        },
      )
          : null,
      errorText: _phoneError,
    );
  }

  Widget _buildSearchButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : () => _handleUserSearch(context),
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
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  // Static method to show the bottom sheet
  static void show(BuildContext context, String sharedWalletId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => InviteMemberBottomSheet(
        sharedWalletId: sharedWalletId,
      ),
    );
  }
}