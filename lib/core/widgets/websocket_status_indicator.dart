import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../services/websocket_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class WebSocketStatusIndicator extends StatefulWidget {
  final WebSocketService webSocketService;
  final bool showLabel;

  const WebSocketStatusIndicator({
    super.key,
    required this.webSocketService,
    this.showLabel = true,
  });

  @override
  State<WebSocketStatusIndicator> createState() => _WebSocketStatusIndicatorState();
}

class _WebSocketStatusIndicatorState extends State<WebSocketStatusIndicator>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _checkConnectionStatus();
    _startStatusMonitoring();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _checkConnectionStatus() {
    final isConnected = widget.webSocketService.isConnected;
    if (_isConnected != isConnected) {
      setState(() {
        _isConnected = isConnected;
      });
      
      if (_isConnected) {
        _pulseController.repeat(reverse: true);
      } else {
        _pulseController.stop();
        _pulseController.reset();
      }
    }
  }

  void _startStatusMonitoring() {
    // Check connection status periodically
    Stream.periodic(const Duration(seconds: 1)).listen((_) {
      if (mounted) {
        _checkConnectionStatus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: _getStatusColor().withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: _getStatusColor().withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.scale(
                scale: _isConnected ? _pulseAnimation.value : 1.0,
                child: Container(
                  width: 8.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: _getStatusColor(),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              if (widget.showLabel) ...[
                SizedBox(width: 6.w),
                Text(
                  _getStatusText(),
                  style: AppTextStyles.caption.copyWith(
                    color: _getStatusColor(),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Color _getStatusColor() {
    return _isConnected 
        ? AppColors.success 
        : AppColors.warning;
  }

  String _getStatusText() {
    return _isConnected ? 'LIVE' : 'DEMO';
  }
}