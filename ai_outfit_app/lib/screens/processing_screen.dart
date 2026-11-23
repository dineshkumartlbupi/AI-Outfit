import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme.dart';
import '../state/tryon_provider.dart';
import 'result_screen.dart';

class ProcessingScreen extends StatefulWidget {
  const ProcessingScreen({super.key});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  bool _hasNavigated = false;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TryOnProvider>();

    // Check if generation completed
    if (!provider.isGenerating && provider.currentJob != null && !_hasNavigated) {
      if (provider.currentJob!.resultImageUrl != null) {
        _hasNavigated = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ResultScreen(),
            ),
          );
        });
      }
    }

    return PopScope(
      canPop: !provider.isGenerating,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 28),
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.2,
              colors: [Color(0xFF240E2C), AppTheme.bgDark],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Animated Pulse Logo
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primary.withOpacity(0.3),
                          blurRadius: 36,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      value: provider.progress / 100.0,
                      strokeWidth: 4,
                      backgroundColor: Colors.white12,
                      valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.auto_awesome, color: AppTheme.primary, size: 28),
                      const SizedBox(height: 4),
                      Text(
                        '${provider.progress}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 40),

              const Text(
                'AI Magic In Progress ✨',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 12),

              Text(
                provider.statusMessage.isNotEmpty
                    ? provider.statusMessage
                    : 'Applying fashion diffusion neural network...',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 36),

              // Fashion tips carousel card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.cardDark.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.strokeDark),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.lightbulb_outline, color: Colors.amber, size: 22),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Did you know? Virtual try-on AI aligns fabric draping, shadow depth, and folds to your exact posture.',
                        style: TextStyle(color: Colors.white60, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
