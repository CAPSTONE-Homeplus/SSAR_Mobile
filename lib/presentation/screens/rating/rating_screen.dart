import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_clean/core/router/app_router.dart';
import 'package:home_clean/presentation/widgets/custom_app_bar.dart';

import '../../../../core/constant/colors.dart';
import '../../../../core/constant/size_config.dart';
import '../../../domain/entities/rating_request/rating_request.dart';
import '../../blocs/feedbacks/rating_order_bloc.dart';

class RatingReviewPage extends StatefulWidget {
  String orderId;
  RatingReviewPage({super.key, required this.orderId});

  @override
  State<RatingReviewPage> createState() => _RatingReviewPageState();
}

class _RatingReviewPageState extends State<RatingReviewPage> {
  double _rating = 0;
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<RatingOrderBloc, RatingOrderState>(
        listener: (context, state) {
      if (state is RatingOrderLoaded) {
        _showSuccessDialog(context);
      }
    },
    child: Scaffold(
      appBar: CustomAppBar(
        title: 'Đánh giá',
        backgroundColor: AppColors.primaryColor,
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 20 * SizeConfig.fem,
            vertical: 24 * SizeConfig.hem,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildEmotionIcon(),
              _buildTitleTexts(),
              _buildStarRating(),
              _buildRatingHint(),
              _buildCommentField(),
              _buildSuggestionChips(),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    ),
    );
  }

  Widget _buildEmotionIcon() {
    IconData icon = _rating >= 4
        ? Icons.sentiment_very_satisfied
        : _rating >= 3
        ? Icons.sentiment_satisfied
        : _rating >= 2
        ? Icons.sentiment_neutral
        : _rating >= 1
        ? Icons.sentiment_dissatisfied
        : Icons.sentiment_very_dissatisfied;
    Color color = _rating >= 4
        ? Colors.green
        : _rating >= 3
        ? Colors.lightGreen
        : _rating >= 2
        ? Colors.amber
        : _rating >= 1
        ? Colors.orange
        : Colors.grey;
    return Container(
      padding: EdgeInsets.all(12 * SizeConfig.fem),
      decoration: BoxDecoration(
        color: Colors.green[50],
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 45 * SizeConfig.fem, color: color),
    );
  }


  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20 * SizeConfig.fem),
          ),
          child: Container(
            padding: EdgeInsets.all(24 * SizeConfig.fem),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 80 * SizeConfig.fem,
                ),
                SizedBox(height: 16 * SizeConfig.hem),
                Text(
                  'Cảm ơn',
                  style: GoogleFonts.poppins(
                    fontSize: 24 * SizeConfig.ffem,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 12 * SizeConfig.hem),
                Text(
                  'Đánh giá của bạn đã được ghi nhận. Chân thành cảm ơn sự phản hồi!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16 * SizeConfig.ffem,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 24 * SizeConfig.hem),
                ElevatedButton(
                  onPressed: () {
                    AppRouter.navigateToHome();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 52 * SizeConfig.hem),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10 * SizeConfig.fem),
                    ),
                  ),
                  child: Text(
                    'Về trang chủ',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16 * SizeConfig.ffem,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTitleTexts() {
    return Column(
      children: [
        SizedBox(height: 16 * SizeConfig.hem),
        Text(
          'Đánh giá dịch vụ',
          style: GoogleFonts.poppins(
            fontSize: 20 * SizeConfig.ffem,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8 * SizeConfig.hem),
        Text(
          'Hãy cho chúng tôi biết bạn cảm thấy thế nào về dịch vụ',
          style: GoogleFonts.poppins(
            fontSize: 14 * SizeConfig.ffem,
            color: Colors.black54,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 24 * SizeConfig.hem),
      ],
    );
  }

  Widget _buildStarRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _rating = index + 1;
            });
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8 * SizeConfig.fem),
            child: Icon(
              index < _rating ? Icons.star : Icons.star_border,
              color: index < _rating ? Colors.amber : Colors.grey,
              size: 36 * SizeConfig.fem,
            ),
          ),
        );
      }),
    );
  }

  Widget _buildRatingHint() {
    String hint = _rating == 5
        ? 'Tuyệt vời!'
        : _rating == 4
        ? 'Hài lòng'
        : _rating == 3
        ? 'Tạm được'
        : _rating == 2
        ? 'Cần cải thiện'
        : _rating == 1
        ? 'Không hài lòng'
        : 'Chọn đánh giá của bạn';
    Color color = _rating >= 4
        ? Colors.green
        : _rating >= 3
        ? Colors.lightGreen
        : _rating >= 2
        ? Colors.amber
        : _rating >= 1
        ? Colors.orange
        : Colors.grey;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20 * SizeConfig.hem),
      child: Text(
        hint,
        style: GoogleFonts.poppins(
          fontSize: 16 * SizeConfig.ffem,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }

  Widget _buildCommentField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12 * SizeConfig.fem),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: TextField(
        controller: _commentController,
        maxLines: 4,
        decoration: InputDecoration(
          hintText: 'Chia sẻ cảm nhận của bạn về dịch vụ...',
          hintStyle: GoogleFonts.poppins(
            fontSize: 14 * SizeConfig.ffem,
            color: Colors.grey[400],
          ),
          contentPadding: EdgeInsets.all(16 * SizeConfig.fem),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildSuggestionChips() {
    List<String> suggestions = [
      'Nhân viên thân thiện',
      'Dịch vụ nhanh chóng',
      'Sạch sẽ, gọn gàng',
      'Giá cả hợp lý',
    ];
    return Padding(
      padding: EdgeInsets.only(top: 12 * SizeConfig.hem, bottom: 24 * SizeConfig.hem),
      child: Wrap(
        spacing: 8 * SizeConfig.fem,
        runSpacing: 8 * SizeConfig.hem,
        children: suggestions
            .map((label) => _buildSuggestionChip(label, _commentController))
            .toList(),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        context.read<RatingOrderBloc>().add(
          SubmitRatingEvent(
            ratingRequest: RatingRequest(
              serviceOrderId: widget.orderId,
              rating: _rating.toInt(),
              comments: _commentController.text,
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: Colors.white,
        minimumSize: Size(double.infinity, 52 * SizeConfig.hem),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10 * SizeConfig.fem),
        ),
      ),
      child: Text(
        'Gửi đánh giá',
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w600,
          fontSize: 16 * SizeConfig.ffem,
        ),
      ),
    );
  }

  Widget _buildSuggestionChip(String label, TextEditingController controller) {
    return GestureDetector(
      onTap: () {
        final currentText = controller.text;
        if (currentText.isEmpty) {
          controller.text = label;
        } else if (!currentText.contains(label)) {
          controller.text = currentText + (currentText.endsWith('.') || currentText.endsWith('!') || currentText.endsWith('?') ? ' ' : '. ') + label;
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: 12 * SizeConfig.fem,
            vertical: 8 * SizeConfig.hem
        ),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(16 * SizeConfig.fem),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12 * SizeConfig.ffem,
            color: Colors.grey[700],
          ),
        ),
      ),
    );
  }
}