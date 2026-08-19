import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';

/// Parental gate: a challenge of 3 random digits is shown spelled out as
/// Arabic number-words (e.g. "ثلاثة - تسعة - صفر"); the child/adult must tap
/// the matching digits on a numeric keypad in order. Mirrors the original
/// `LockFragment.java` behavior: wrong entry after all 3 digits are tapped
/// resets and shakes; there's no attempt limit or timeout by design (ported
/// as-is from the original app).
class ParentalGateScreen extends StatefulWidget {
  const ParentalGateScreen({super.key});

  @override
  State<ParentalGateScreen> createState() => _ParentalGateScreenState();
}

class _ParentalGateScreenState extends State<ParentalGateScreen>
    with SingleTickerProviderStateMixin {
  static const _digitWords = [
    'صفر', 'واحد', 'اثنان', 'ثلاثة', 'أربعة',
    'خمسة', 'ستة', 'سبعة', 'ثمانية', 'تسعة',
  ];

  late List<int> _challenge;
  final List<int> _entered = [];

  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _challenge = _generateChallenge();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(_shakeController);
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  List<int> _generateChallenge() {
    final rng = Random();
    return List.generate(3, (_) => rng.nextInt(10));
  }

  void _onDigitTapped(int digit) {
    setState(() => _entered.add(digit));

    if (!_isPrefixValidSoFar()) {
      if (_entered.length == 3) {
        _onWrongEntry();
      }
      return;
    }

    if (_entered.length == 3) {
      _onSuccess();
    }
  }

  bool _isPrefixValidSoFar() {
    for (var i = 0; i < _entered.length; i++) {
      if (_entered[i] != _challenge[i]) return false;
    }
    return true;
  }

  void _onWrongEntry() async {
    await _shakeController.forward(from: 0);
    setState(() {
      _entered.clear();
      _challenge = _generateChallenge();
    });
  }

  void _onSuccess() {
    context.pushReplacement(AppRoutes.account);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'اطلب من أحد الوالدين إدخال الأرقام التالية',
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.md),
              AnimatedBuilder(
                animation: _shakeAnimation,
                builder: (context, child) {
                  final offset = sin(_shakeAnimation.value * pi * 6) * 8;
                  return Transform.translate(offset: Offset(offset, 0), child: child);
                },
                child: Text(
                  _challenge.map((d) => _digitWords[d]).join(' - '),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                _entered.map((d) => _digitWords[d]).join(' - '),
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              _Keypad(onDigit: _onDigitTapped),
            ],
          ),
        ),
      ),
    );
  }
}

class _Keypad extends StatelessWidget {
  const _Keypad({required this.onDigit});

  final ValueChanged<int> onDigit;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      alignment: WrapAlignment.center,
      children: List.generate(10, (digit) => _KeypadButton(digit: digit, onTap: onDigit)),
    );
  }
}

class _KeypadButton extends StatelessWidget {
  const _KeypadButton({required this.digit, required this.onTap});

  final int digit;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 72,
      height: 72,
      child: FilledButton.tonal(
        style: FilledButton.styleFrom(
          shape: const CircleBorder(),
          backgroundColor: theme.colorScheme.secondaryContainer,
        ),
        onPressed: () => onTap(digit),
        child: Text(
          '$digit',
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
