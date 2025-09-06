import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:typed_data';
import 'level_data.dart';

extension OffsetExt on Offset {
  Offset normalized() {
    final d = distance;
    if (d == 0) return Offset.zero;
    return this / d;
  }
}

enum Difficulty { easy, normal, hard }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  runApp(const GyroPongApp());
}

// Simple block model for block-breaking mode
class Block {
  final int row;
  final int col;
  int health;
  final int maxHealth;

  Block({required this.row, required this.col, required int health})
      : health = health,
        maxHealth = health;
}

class GyroPongApp extends StatelessWidget {
  const GyroPongApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gyro Pong',
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
      home: const DifficultySelectionScreen(),
    );
  }
}

class DifficultySelectionScreen extends StatelessWidget {
  const DifficultySelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F3460),
              Color(0xFF16213E),
              Color(0xFF0F3460),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.sports_esports,
                        color: Colors.white,
                        size: 48,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'GYRO PONG',
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 2),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Select Your Challenge',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.8)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
            _DifficultyButton(
              difficulty: Difficulty.easy,
              description: 'Large paddle, slower ball',
              onSelected: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const GamePage(difficulty: Difficulty.easy)),
                );
              },
            ),
            const SizedBox(height: 20),
            _DifficultyButton(
              difficulty: Difficulty.normal,
              description: 'Default paddle and ball speed',
              onSelected: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const GamePage(difficulty: Difficulty.normal)),
                );
              },
            ),
            const SizedBox(height: 20),
            _DifficultyButton(
              difficulty: Difficulty.hard,
              description: 'Small paddle, faster ball',
              onSelected: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const GamePage(difficulty: Difficulty.hard)),
                );
              },
            ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DifficultyButton extends StatelessWidget {
  final Difficulty difficulty;
  final String description;
  final VoidCallback onSelected;

  const _DifficultyButton({
    required this.difficulty,
    required this.description,
    required this.onSelected,
  });

  String get _difficultyName {
    switch (difficulty) {
      case Difficulty.easy:
        return 'Easy';
      case Difficulty.normal:
        return 'Normal';
      case Difficulty.hard:
        return 'Hard';
    }
  }

  Color get _difficultyColor {
    switch (difficulty) {
      case Difficulty.easy:
        return Colors.green;
      case Difficulty.normal:
        return Colors.orange;
      case Difficulty.hard:
        return Colors.red;
    }
  }

  IconData get _difficultyIcon {
    switch (difficulty) {
      case Difficulty.easy:
        return Icons.sentiment_satisfied;
      case Difficulty.normal:
        return Icons.sentiment_neutral;
      case Difficulty.hard:
        return Icons.whatshot;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onSelected,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _difficultyColor.withOpacity(0.3),
                  _difficultyColor.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _difficultyColor.withOpacity(0.6),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: _difficultyColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _difficultyColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _difficultyIcon,
                    color: _difficultyColor,
                    size: 32,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _difficultyName,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: _difficultyColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: _difficultyColor.withOpacity(0.7),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GamePage extends StatefulWidget {
  final Difficulty difficulty;
  const GamePage({super.key, this.difficulty = Difficulty.normal});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  // Layout
  late double screenWidth;
  late double screenHeight;

  // Game
  late Difficulty _difficulty;
  double _scoreMultiplier = 1.0;
  bool _showModeIndicator = true;

  // Paddle
  double paddleWidth = 140;
  double paddleHeight = 18;
  double paddleX = 0; // paddle center x (direct control)
  double _paddleVelocity = 0.0; // paddle velocity for momentum

  // Ball
  Offset? ballPos;
  Offset? ballVel;
  double ballRadius = 10;
  double _ballSpeed = 280; // pixels per second

  // Game
  int score = 0;
  int highScore = 0;
  int lives = 3;
  bool running = false;
  bool _isStageCleared = false;
  bool _isGameWon = false;

  // Sensors
  StreamSubscription? _gyroSub;
  StreamSubscription? _accelSub;
  double sensitivity = 800.0; // tuning (Ultra high for immediate response)
  double sensitivityMultiplier = 2.0; // Multiplier for instant reactions
  double controlCurveFactor = 1.5; // New: for non-linear control response
  // control tuning
  double deadzone = 0.01; // Minimal deadzone for instant response
  double responsiveness = 0.95; // How directly paddle follows tilt (0-1)
  double momentum = 0.1; // Momentum factor for smooth stopping
  double _lastTiltRate = 0.0;
  double _lastAccelX = 0.0;
  bool _showDebugOverlay = false;
  double _fps = 60.0;
  bool soundEnabled = true;
  bool hapticsEnabled = true;
  double volume = 1.0;
  // per-event multipliers
  double hitVolumeMultiplier = 0.9;
  double gameOverVolumeMultiplier = 1.0;

  late final AudioPlayer _audioPlayer;
  Uint8List? _hitSoundBytes;
  Uint8List? _gameOverSoundBytes;
  Timer? _previewDebounceTimer;

  // Animation
  Timer? _gameTimer;
  final Stopwatch _stopwatch = Stopwatch();
  late double lastTick;

  // Ads
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  // Block-breaking mode
  List<Block> blocks = [];
  int level = 1;
  int remainingBlocks = 0;

  @override
  void initState() {
    super.initState();
    _difficulty = widget.difficulty;
    _applyDifficultySettings();
    Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _showModeIndicator = false;
        });
      }
    });
    lastTick = 0;
    _loadHighScore();
    _loadSensitivity(); // This will now load both sensitivity and multiplier
    _loadFeedbackSettings();
    _loadControlSettings();
    _loadAds();
    _startGyro();
    _audioPlayer = AudioPlayer();
    // generate synthetic beep sounds (layered)
    _regenerateSounds();
  }

  void _applyDifficultySettings() {
    setState(() {
      switch (_difficulty) {
        case Difficulty.easy:
          paddleWidth = 200;
          _ballSpeed = 220;
          _scoreMultiplier = 0.5;
          break;
        case Difficulty.normal:
          paddleWidth = 140;
          _ballSpeed = 280;
          _scoreMultiplier = 1.0;
          break;
        case Difficulty.hard:
          paddleWidth = 80;
          _ballSpeed = 350;
          _scoreMultiplier = 2.0;
          break;
      }
    });
  }

  Color _getDifficultyColor() {
    switch (_difficulty) {
      case Difficulty.easy:
        return Colors.green;
      case Difficulty.normal:
        return Colors.orange;
      case Difficulty.hard:
        return Colors.red;
    }
  }

  IconData _getDifficultyIcon() {
    switch (_difficulty) {
      case Difficulty.easy:
        return Icons.sentiment_satisfied;
      case Difficulty.normal:
        return Icons.sentiment_neutral;
      case Difficulty.hard:
        return Icons.whatshot;
    }
  }

  Future<void> _loadControlSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      deadzone = prefs.getDouble('deadzone') ?? deadzone;
      responsiveness = prefs.getDouble('responsiveness') ?? responsiveness;
      momentum = prefs.getDouble('momentum') ?? momentum;
      controlCurveFactor =
          prefs.getDouble('controlCurveFactor') ?? controlCurveFactor;
    });
  }

  Future<void> _saveControlSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('deadzone', deadzone);
    await prefs.setDouble('responsiveness', responsiveness);
    await prefs.setDouble('momentum', momentum);
    await prefs.setDouble('controlCurveFactor', controlCurveFactor);
  }

  void _regenerateSounds() {
    _hitSoundBytes = _generateWavLayered([880, 1320], 0.06,
        vol: volume * hitVolumeMultiplier);
    _gameOverSoundBytes = _generateWavLayered([220, 330, 440], 0.45,
        vol: volume * gameOverVolumeMultiplier);
  }

  Future<void> _playPreview(Uint8List? bytes) async {
    if (!soundEnabled) return;
    if (bytes == null) return;
    try {
      await _audioPlayer.stop();
    } catch (_) {}
    try {
      await _audioPlayer.play(BytesSource(bytes));
    } catch (_) {}
  }

  void _debouncedPreview(Uint8List? bytes, {int ms = 150}) {
    _previewDebounceTimer?.cancel();
    _previewDebounceTimer = Timer(Duration(milliseconds: ms), () {
      _playPreview(bytes);
    });
  }

  Uint8List _generateWavLayered(List<double> freqs, double duration,
      {int sampleRate = 44100, double vol = 1.0}) {
    final int samples = (duration * sampleRate).round();
    final ByteData data = ByteData(44 + samples * 2);
    // RIFF header
    data.setUint8(0, 0x52);
    data.setUint8(1, 0x49);
    data.setUint8(2, 0x46);
    data.setUint8(3, 0x46);
    data.setUint32(4, 36 + samples * 2, Endian.little);
    data.setUint8(8, 0x57);
    data.setUint8(9, 0x41);
    data.setUint8(10, 0x56);
    data.setUint8(11, 0x45);
    data.setUint8(12, 0x66);
    data.setUint8(13, 0x6d);
    data.setUint8(14, 0x74);
    data.setUint8(15, 0x20);
    data.setUint32(16, 16, Endian.little);
    data.setUint16(20, 1, Endian.little);
    data.setUint16(22, 1, Endian.little);
    data.setUint32(24, sampleRate, Endian.little);
    data.setUint32(28, sampleRate * 2, Endian.little);
    data.setUint16(32, 2, Endian.little);
    data.setUint16(34, 16, Endian.little);
    data.setUint8(36, 0x64);
    data.setUint8(37, 0x61);
    data.setUint8(38, 0x74);
    data.setUint8(39, 0x61);
    data.setUint32(40, samples * 2, Endian.little);

    for (int i = 0; i < samples; i++) {
      final t = i / sampleRate;
      // ADSR envelope: short attack, quick decay, sustain, release
      final attack = 0.005; // 5ms
      final decay = 0.03; // 30ms
      final sustainLevel = 0.6;
      final release = 0.05; // 50ms
      double env;
      final time = t;
      if (time < attack) {
        env = time / attack;
      } else if (time < attack + decay) {
        env = 1 - (time - attack) / decay * (1 - sustainLevel);
      } else if (time < duration - release) {
        env = sustainLevel;
      } else {
        env = (duration - time) / release * sustainLevel;
        if (env < 0) env = 0;
      }

      double sample = 0.0;
      for (int fi = 0; fi < freqs.length; fi++) {
        final double f = freqs[fi];
        // slight detune for higher partials
        final detune = 1.0 + fi * 0.002;
        sample += sin(2 * pi * f * detune * t);
      }
      // normalize by number of freqs and apply envelope and volume
      sample = sample / freqs.length * env * vol * 0.8;
      final int intSample = (sample * 32767).toInt();
      data.setInt16(44 + i * 2, intSample, Endian.little);
    }

    return data.buffer.asUint8List();
  }

  Future<void> _loadFeedbackSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      soundEnabled = prefs.getBool('soundEnabled') ?? true;
      hapticsEnabled = prefs.getBool('hapticsEnabled') ?? true;
      volume = prefs.getDouble('volume') ?? 1.0;
      hitVolumeMultiplier = prefs.getDouble('hitVolumeMultiplier') ?? 0.9;
      gameOverVolumeMultiplier =
          prefs.getDouble('gameOverVolumeMultiplier') ?? 1.0;
    });
  }

  Future<void> _saveFeedbackSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('soundEnabled', soundEnabled);
    await prefs.setBool('hapticsEnabled', hapticsEnabled);
    await prefs.setDouble('volume', volume);
    await prefs.setDouble('hitVolumeMultiplier', hitVolumeMultiplier);
    await prefs.setDouble('gameOverVolumeMultiplier', gameOverVolumeMultiplier);
  }

  Future<void> _loadSensitivity() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      sensitivity = prefs.getDouble('sensitivity') ?? sensitivity;
      sensitivityMultiplier =
          prefs.getDouble('sensitivityMultiplier') ?? sensitivityMultiplier;
    });
  }

  Future<void> _saveSensitivity() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('sensitivity', sensitivity);
    await prefs.setDouble('sensitivityMultiplier', sensitivityMultiplier);
  }

  Future<void> _loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() => highScore = prefs.getInt('highScore') ?? 0);
  }

  Future<void> _saveHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('highScore', highScore);
  }

  void _loadAds() {
    // Banner (test ad unit id)
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (_) => setState(() {}),
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    );
    _bannerAd!.load();

    // Interstitial (test id)
    _loadInterstitial();
  }

  void _loadInterstitial() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712',
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _interstitialAd!.setImmersiveMode(true);
          _interstitialAd!.fullScreenContentCallback =
              FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              try {
                ad.dispose();
              } catch (_) {}
              _interstitialAd = null;
              _loadInterstitial();
            },
            onAdFailedToShowFullScreenContent: (ad, err) {
              try {
                ad.dispose();
              } catch (_) {}
              _interstitialAd = null;
              _loadInterstitial();
            },
          );
        },
        onAdFailedToLoad: (err) {
          _interstitialAd = null;
          // try again later
          Future.delayed(const Duration(seconds: 10), _loadInterstitial);
        },
      ),
    );
  }

  void _startGyro() {
    // Keep a recent accelerometer reading as a fallback (tilt-based control)
    _accelSub = accelerometerEvents.listen((AccelerometerEvent a) {
      // typical device portrait: x axis is left/right tilt
      _lastAccelX = a.x;

      // Use accelerometer as the primary input for tilt control
      // Normalize tilt to a [-1, 1] range for consistent curve application
      const maxTilt =
          3.0; // Corresponds to a reasonable tilt angle (decreased from 5.0 for more responsiveness)
      double normalizedTilt = (-_lastAccelX / maxTilt).clamp(-1.0, 1.0);
      _lastTiltRate = normalizedTilt;

      // Apply minimal deadzone only - no smoothing for immediate response
      double rate = 0.0;
      if (normalizedTilt.abs() > deadzone) {
        rate = normalizedTilt;
      }
      
      // Store raw tilt rate for direct paddle control
      _lastTiltRate = rate;
    });

    // Gyroscope can be a secondary input or disabled if tilt is preferred
    _gyroSub = gyroscopeEvents.listen((GyroscopeEvent e) {
      // e.y is rotation rate around Y axis (rad/s).
      // This can be used to supplement the accelerometer, but for now, we'll rely on tilt.
      // You could add logic here to combine gyro and accelerometer if desired.
    });
  }

  void _applyPreset(String name) {
    if (name == 'low') {
      setState(() {
        sensitivity = 200.0;  // Increased from 120
        deadzone = 0.06;
        responsiveness = 0.9;
        momentum = 0.15;
      });
    } else if (name == 'medium') {
      setState(() {
        sensitivity = 350.0;  // Increased from 200
        deadzone = 0.03;
        responsiveness = 0.95;
        momentum = 0.08;
      });
    } else if (name == 'high') {
      setState(() {
        sensitivity = 500.0;  // Increased from 320
        deadzone = 0.01;
        responsiveness = 0.98;
        momentum = 0.03;
      });
    }
    _saveSensitivity();
    _saveControlSettings();
  }

  void _calibrate() async {
    // Capture a short baseline of gyro while device is held steady
    const samples = 20;
    double sum = 0;
    int got = 0;
    late StreamSubscription sub;
    sub = gyroscopeEvents.listen((GyroscopeEvent e) {
      sum += e.y;
      got++;
      if (got >= samples) {
        sub.cancel();
        final avg = sum / got;
        setState(() {
          _lastTiltRate = -avg;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Calibrated: bias=${avg.toStringAsFixed(4)}')),
        );
      }
    });
    // timeout fallback
    Future.delayed(const Duration(milliseconds: 800), () {
      try {
        sub.cancel();
      } catch (_) {}
    });
  }

  void _clampPaddle() {
    final half = paddleWidth / 2;
    paddleX = paddleX.clamp(half, screenWidth - half);
  }

  // Removed _clampTargetPaddle - using direct boundary clamping for immediate response

  // Fixed timestep physics update
  double _timeAccumulator = 0.0;
  final double _fixedDt = 1 / 120.0; // Run physics at 120Hz

  void _onTick(Duration elapsed) {
    if (!running) {
      _stopwatch.stop(); // Pause stopwatch when not running
      return;
    }
    if (!_stopwatch.isRunning) {
      _stopwatch.start();
    }

    final t = elapsed.inMilliseconds / 1000.0;
    double frameTime = (lastTick == 0) ? _fixedDt : (t - lastTick);
    lastTick = t;

    // update smoothed FPS
    if (frameTime > 0) {
      final currentFps = 1.0 / frameTime;
      _fps = _fps * 0.85 + currentFps * 0.15;
    }

    _timeAccumulator += frameTime;

    while (_timeAccumulator >= _fixedDt) {
      _updatePhysics(_fixedDt);
      _timeAccumulator -= _fixedDt;
    }

    // Direct paddle movement - no smoothing delays
    setState(() {
      // Direct control with immediate response
      final directMovement = _lastTiltRate * sensitivity * sensitivityMultiplier * _fixedDt * responsiveness;
      
      // Add small momentum for natural feel without lag
      _paddleVelocity = _paddleVelocity * (1.0 - momentum) + directMovement * momentum;
      
      // Apply movement directly
      paddleX += directMovement + _paddleVelocity;
      
      // Simple boundary clamping
      final half = paddleWidth / 2;
      paddleX = paddleX.clamp(half, screenWidth - half);
    });
  }

  void _updatePhysics(double dt) {
    // Physics update now handles only ball and block collisions
    // Paddle movement is handled directly in render loop for zero-lag response

    // Update ball
    ballPos = ballPos! + ballVel! * dt;

    // Ball-block collisions (simple AABB collision per block)
    if (blocks.isNotEmpty) {
      // define block area: top margin adjusted for HUD panel, block area height 180
      final topMargin = 140.0; // Generous margin to ensure no overlap with HUD panel
      final blockAreaHeight = 180.0;
      final cols = 8;
      final rows = 5;
      final gap = 6.0;
      final blockWidth = (screenWidth - (cols + 1) * gap) / cols;
      final blockHeight = (blockAreaHeight - (rows + 1) * gap) / rows;

      for (int i = blocks.length - 1; i >= 0; i--) {
        final b = blocks[i];
        final left = gap + b.col * (blockWidth + gap);
        final top = topMargin + gap + b.row * (blockHeight + gap);
        final rect = Rect.fromLTWH(left, top, blockWidth, blockHeight);
        // closest point to ball
        final cx = ballPos!.dx.clamp(rect.left, rect.right);
        final cy = ballPos!.dy.clamp(rect.top, rect.bottom);
        final d = Offset(ballPos!.dx - cx, ballPos!.dy - cy);
        if (d.distance <= ballRadius) {
          // hit
          b.health -= 1;
          // reflect ball: simple invert y and nudge x based on hit side
          // determine overlap side
          final center = rect.center;
          final dx = (ballPos!.dx - center.dx).clamp(-1.0, 1.0);
          ballVel = Offset(ballVel!.dx + dx * 60, -ballVel!.dy.abs());
          // award score when destroyed
          if (b.health <= 0) {
            blocks.removeAt(i);
            remainingBlocks = blocks.length;
            score += (100 * _scoreMultiplier).round();
            if (remainingBlocks == 0) {
              _stageCleared();
            }
          } else {
            score += (20 * _scoreMultiplier).round(); // damage points
          }
          if (score > highScore) {
            highScore = score;
            _saveHighScore();
          }
          // small break to avoid multiple collisions in same tick
          break;
        }
      }
    }

    // Walls (left/right)
    if (ballPos!.dx - ballRadius < 0) {
      ballPos = Offset(ballRadius, ballPos!.dy);
      ballVel = Offset(-ballVel!.dx, ballVel!.dy);
    }
    if (ballPos!.dx + ballRadius > screenWidth) {
      ballPos = Offset(screenWidth - ballRadius, ballPos!.dy);
      ballVel = Offset(-ballVel!.dx, ballVel!.dy);
    }

    // top wall / ceiling - positioned below HUD panel
    double ceilingY = 130.0; // Below HUD panel area with generous margin
    if (ballPos!.dy - ballRadius < ceilingY) {
      ballPos = Offset(ballPos!.dx, ceilingY + ballRadius);
      ballVel = Offset(ballVel!.dx, -ballVel!.dy);
    }

    // Paddle collision
    final paddleTop = screenHeight -
        paddleHeight -
        24 -
        (_bannerAd == null ? 0 : _bannerAd!.size.height.toDouble());
    final paddleRect = Rect.fromCenter(
      center: Offset(paddleX, paddleTop + paddleHeight / 2),
      width: paddleWidth,
      height: paddleHeight,
    );
    if (ballPos!.dy + ballRadius >= paddleRect.top &&
        ballPos!.dy < paddleRect.top + 8 &&
        ballVel!.dy > 0) {
      if (ballPos!.dx >= paddleRect.left && ballPos!.dx <= paddleRect.right) {
        // reflect
        final hitPos = (ballPos!.dx - paddleX) / (paddleWidth / 2); // -1 to 1
        final influence = hitPos.clamp(-1.0, 1.0);
        // Reflect based on current velocity, influenced by hit position
        double newDx = ballVel!.dx + influence * 150;
        double newDy = -ballVel!.dy.abs(); // Ensure it always goes up

        ballVel = Offset(newDx, newDy);
        // Normalize and apply constant speed
        final currentSpeed = ballVel!.distance;
        if (currentSpeed > 0) {
          ballVel = ballVel! / currentSpeed * _ballSpeed;
        }

        // Angle correction to prevent extreme horizontal/vertical bounces
        final minVerticalFactor = 0.3; // e.g., must be at least 30% vertical
        if (ballVel!.dy.abs() / _ballSpeed < minVerticalFactor) {
          ballVel = Offset(
              ballVel!.dx.sign *
                  _ballSpeed *
                  sqrt(1 - minVerticalFactor * minVerticalFactor),
              -minVerticalFactor * _ballSpeed);
        }

        score += (1 * _scoreMultiplier).round();
        // feedback
        if (hapticsEnabled) {
          try {
            HapticFeedback.lightImpact();
          } catch (_) {}
        }
        if (soundEnabled) {
          try {
            if (_hitSoundBytes != null) {
              _audioPlayer.play(BytesSource(_hitSoundBytes!));
            }
          } catch (_) {}
        }
        if (score > highScore) {
          highScore = score;
          _saveHighScore();
        }
      }
    }

    // Ball lost
    if (ballPos!.dy - ballRadius > screenHeight) {
      running = false;
      lives--;
      if (lives <= 0) {
        _showGameOver();
      } else {
        // Reset ball and paddle for the next turn
        _resetBallAndPaddle();
        // Briefly pause before resuming
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            setState(() {
              running = true;
              _stopwatch.start();
              lastTick = _stopwatch.elapsed.inMilliseconds / 1000.0;
            });
          }
        });
      }
    }
  }

  void _showGameOver() {
    if (hapticsEnabled) {
      try {
        HapticFeedback.heavyImpact();
      } catch (_) {}
    }
    if (soundEnabled) {
      try {
        if (_gameOverSoundBytes != null) {
          _audioPlayer.play(BytesSource(_gameOverSoundBytes!));
        }
      } catch (_) {}
    }
    _interstitialAd?.show();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Game Over'),
        content: Text('Score: $score\nHigh Score: $highScore'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetGame();
            },
            child: const Text('Restart'),
          ),
        ],
      ),
    );
  }

  void _resetBallAndPaddle() {
    final centerX = screenWidth / 2;
    paddleX = centerX;
    _paddleVelocity = 0.0; // Reset paddle momentum
    ballPos = Offset(centerX, screenHeight / 2);
    final rand = Random();
    final initialAngle = (rand.nextDouble() * (pi / 2) + pi / 4); // 45-135 deg
    final initialDx = cos(initialAngle) * (rand.nextBool() ? 1 : -1);
    final initialDy = -sin(initialAngle);
    ballVel = Offset(initialDx, initialDy) * _ballSpeed;
  }

  void _stageCleared() {
    running = false;
    score += (500 * _scoreMultiplier).round(); // Stage clear bonus
    if (score > highScore) {
      highScore = score;
      _saveHighScore();
    }
    if (level >= gameLevels.length) {
      setState(() {
        _isGameWon = true;
      });
    } else {
      setState(() {
        _isStageCleared = true;
      });
    }
  }

  void _startNextStage() {
    setState(() {
      level++;
      _isStageCleared = false;
      _resetGame(resetScore: false);
    });
  }

  void _resetGame({bool resetScore = true}) {
    setState(() {
      if (resetScore) {
        score = 0;
        level = 1;
        lives = 3;
      }
      _isStageCleared = false;
      _isGameWon = false;
      running = true;
      _resetBallAndPaddle();
      // start level blocks
      _startLevel(level);
      // start game loop
      lastTick = 0;
      _timeAccumulator = 0.0;
      _stopwatch.reset();
      _stopwatch.start();
      _gameTimer?.cancel();
      _gameTimer = Timer.periodic(
          const Duration(milliseconds: 16), (_) => _onTick(_stopwatch.elapsed));
    });
  }

  void _startLevel(int lvl) {
    blocks.clear();
    if (lvl > gameLevels.length) {
      // This case is handled by the _isGameWon flag now
      return;
    }
    final levelData = gameLevels[lvl - 1];
    _ballSpeed = levelData.ballSpeed;
    for (final blockData in levelData.blocks) {
      blocks.add(Block(
        row: blockData.row,
        col: blockData.col,
        health: blockData.health,
      ));
    }
    remainingBlocks = blocks.length;
  }

  @override
  void dispose() {
    _gyroSub?.cancel();
    _accelSub?.cancel();
    _gameTimer?.cancel();
    _stopwatch.stop();
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _previewDebounceTimer?.cancel();
    try {
      _audioPlayer.dispose();
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        screenWidth = constraints.maxWidth;
        screenHeight = constraints.maxHeight;
        // initial positions
        if (ballPos == null || ballVel == null) {
          final centerX = screenWidth / 2;
          paddleX = centerX;
          _paddleVelocity = 0.0;
          ballPos = Offset(centerX, screenHeight / 2);
          ballVel = Offset(0.707, -0.707) * _ballSpeed; // 45 deg up-right
        }

        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0D1B2A),
                  Color(0xFF1B263B),
                  Color(0xFF0D1B2A),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
            child: Stack(
              children: [
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    if (!running) {
                      _resetGame();
                    }
                  },
                  child: CustomPaint(
                    painter: _GamePainter(
                      paddleCenter: Offset(
                        paddleX,
                        screenHeight -
                            paddleHeight -
                            24 -
                            (_bannerAd == null
                                ? 0
                                : _bannerAd!.size.height.toDouble()),
                      ),
                      paddleWidth: paddleWidth,
                      paddleHeight: paddleHeight,
                      ballPos: ballPos!,
                      ballVel:
                          running ? ballVel : null, // Pass velocity for debug
                      ballRadius: ballRadius,
                      score: score,
                      highScore: highScore,
                      running: running,
                      blocks: blocks,
                      showDebug: _showDebugOverlay,
                    ),
                  ),
                ),
              ),
              // Banner placeholder at bottom
              if (_bannerAd != null)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  height: _bannerAd!.size.height.toDouble(),
                  child: SizedBox(
                    height: _bannerAd!.size.height.toDouble(),
                    child: AdWidget(ad: _bannerAd!),
                  ),
                ),
              // Score + Settings button
              Positioned(
                top: 30,
                left: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.1),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 18),
                              const SizedBox(width: 6),
                              Text('$score',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.emoji_events, color: Colors.orange, size: 14),
                              const SizedBox(width: 4),
                              Text('Best: $highScore',
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.blue, width: 1),
                            ),
                            child: Text('Level $level',
                                style: const TextStyle(
                                    color: Colors.lightBlue,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(3, (index) => 
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 1),
                                child: Icon(
                                  index < lives ? Icons.favorite : Icons.favorite_border,
                                  color: index < lives ? Colors.red : Colors.grey,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getDifficultyColor().withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: _getDifficultyColor(), width: 1),
                        ),
                        child: Text(
                          _difficulty.name.toUpperCase(),
                          style: TextStyle(
                              color: _getDifficultyColor(),
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.settings, color: Colors.white, size: 20),
                          onPressed: () async {
                        // open settings and update sensitivity live
                        await Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => SettingsPage(
                                  initialSensitivity: sensitivity,
                                  onChanged: (v) {
                                    setState(() => sensitivity = v);
                                    _saveSensitivity();
                                  },
                                  initialSensitivityMultiplier:
                                      sensitivityMultiplier,
                                  onSensitivityMultiplierChanged: (v) {
                                    setState(() => sensitivityMultiplier = v);
                                    _saveSensitivity();
                                  },
                                  initialControlCurve: controlCurveFactor,
                                  onControlCurveChanged: (v) {
                                    setState(() => controlCurveFactor = v);
                                    _saveControlSettings();
                                  },
                                  initialSoundEnabled: soundEnabled,
                                  initialHapticsEnabled: hapticsEnabled,
                                  onSoundChanged: (v) {
                                    setState(() => soundEnabled = v);
                                    _saveFeedbackSettings();
                                  },
                                  onHapticsChanged: (v) {
                                    setState(() => hapticsEnabled = v);
                                    _saveFeedbackSettings();
                                  },
                                  initialVolume: volume,
                                  onVolumeChanged: (v) {
                                    setState(() => volume = v);
                                    _saveFeedbackSettings();
                                    _regenerateSounds();
                                    _debouncedPreview(_hitSoundBytes);
                                  },
                                  initialHitMultiplier: hitVolumeMultiplier,
                                  initialGameOverMultiplier:
                                      gameOverVolumeMultiplier,
                                  onHitMultiplierChanged: (v) {
                                    setState(() => hitVolumeMultiplier = v);
                                    _saveFeedbackSettings();
                                    _regenerateSounds();
                                    _debouncedPreview(_hitSoundBytes);
                                  },
                                  onGameOverMultiplierChanged: (v) {
                                    setState(
                                        () => gameOverVolumeMultiplier = v);
                                    _saveFeedbackSettings();
                                    _regenerateSounds();
                                    _debouncedPreview(_gameOverSoundBytes);
                                  },
                                  // control tuning
                                  initialDeadzone: deadzone,
                                  onDeadzoneChanged: (v) {
                                    setState(() => deadzone = v);
                                    _saveControlSettings();
                                  },
                                  initialResponsiveness: responsiveness,
                                  onResponsivenessChanged: (v) {
                                    setState(() => responsiveness = v);
                                    _saveControlSettings();
                                  },
                                  initialMomentum: momentum,
                                  onMomentumChanged: (v) {
                                    setState(() => momentum = v);
                                    _saveControlSettings();
                                  },
                                  onPresetSelected: (name) =>
                                      _applyPreset(name),
                                  onCalibrate: _calibrate,
                                )));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Start hint
              if (!running && !_isStageCleared && !_isGameWon)
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (lives == 3 && level == 1) ...const [
                          Icon(
                            Icons.sports_esports,
                            color: Colors.white,
                            size: 48,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'GYRO PONG',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                        ] else ...const [
                          Icon(
                            Icons.play_circle_fill,
                            color: Colors.white,
                            size: 48,
                          ),
                        ],
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.touch_app, color: Colors.white70, size: 20),
                              const SizedBox(width: 8),
                              const Text(
                                'Tap to start',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              if (_showModeIndicator)
                Center(
                  child: TweenAnimationBuilder<double>(
                    duration: const Duration(milliseconds: 800),
                    tween: Tween(begin: 0.0, end: 1.0),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Opacity(
                          opacity: value,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  _getDifficultyColor().withOpacity(0.8),
                                  _getDifficultyColor().withOpacity(0.6),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _getDifficultyColor(),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: _getDifficultyColor().withOpacity(0.5),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _getDifficultyIcon(),
                                  color: Colors.white,
                                  size: 24,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  '${_difficulty.name.toUpperCase()} MODE',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              // Stage Cleared Overlay
              if (_isStageCleared)
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.greenAccent, width: 2),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Stage Cleared!',
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.greenAccent),
                        ),
                        const SizedBox(height: 16),
                        Text('Score: $score',
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white)),
                        const SizedBox(height: 8),
                        Text('Lives: $lives',
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white)),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _startNextStage,
                          child: const Text('Next Stage'),
                        ),
                      ],
                    ),
                  ),
                ),
              // Game Won Overlay
              if (_isGameWon)
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.amberAccent, width: 2),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'You Win!',
                          style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.amberAccent),
                        ),
                        const SizedBox(height: 16),
                        Text('Final Score: $score',
                            style: const TextStyle(
                                fontSize: 22, color: Colors.white)),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () => _resetGame(),
                          child: const Text('Play Again'),
                        ),
                      ],
                    ),
                  ),
                ),
              // Debug overlay
              if (_showDebugOverlay && running)
                Positioned(
                  left: 8,
                  top: 100,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('tilt: ${_lastTiltRate.toStringAsFixed(4)}',
                            style: const TextStyle(color: Colors.white)),
                        Text('velocity: ${_paddleVelocity.toStringAsFixed(4)}',
                            style: const TextStyle(color: Colors.white)),
                        Text('paddleX: ${paddleX.toStringAsFixed(1)}',
                            style: const TextStyle(color: Colors.white70)),
                        Text('fps: ${_fps.toStringAsFixed(1)}',
                            style: const TextStyle(color: Colors.white70)),
                        Text('deadzone: ${deadzone.toStringAsFixed(3)}',
                            style: const TextStyle(color: Colors.white70)),
                        Text('sensitivity: ${sensitivity.toStringAsFixed(1)}',
                            style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: _showDebugOverlay 
                  ? [Colors.orange.withOpacity(0.8), Colors.red.withOpacity(0.8)]
                  : [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.2)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: (_showDebugOverlay ? Colors.orange : Colors.white).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: FloatingActionButton(
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Icon(
                  _showDebugOverlay
                      ? Icons.bug_report
                      : Icons.bug_report_outlined,
                  color: Colors.white),
              onPressed: () =>
                  setState(() => _showDebugOverlay = !_showDebugOverlay),
            ),
          ),
        );
      },
    );
  }
}

class _GamePainter extends CustomPainter {
  final Offset paddleCenter;
  final double paddleWidth;
  final double paddleHeight;
  final Offset ballPos;
  final Offset? ballVel;
  final double ballRadius;
  final int score;
  final int highScore;
  final bool running;
  final List<Block> blocks;
  final bool showDebug;

  _GamePainter({
    required this.paddleCenter,
    required this.paddleWidth,
    required this.paddleHeight,
    required this.ballPos,
    this.ballVel,
    required this.ballRadius,
    required this.score,
    required this.highScore,
    required this.running,
    required this.blocks,
    required this.showDebug,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    // draw blocks
    if (blocks.isNotEmpty) {
      final topMargin = 140.0; // Matches collision detection - account for HUD panel
      final blockAreaHeight = 180.0;
      final cols = 8;
      final rows = 5;
      final gap = 6.0;
      final blockWidth = (size.width - (cols + 1) * gap) / cols;
      final blockHeight = (blockAreaHeight - (rows + 1) * gap) / rows;
      for (final b in blocks) {
        final left = gap + b.col * (blockWidth + gap);
        final top = topMargin + gap + b.row * (blockHeight + gap);
        // color by health
        if (b.health >= b.maxHealth) {
          paint.color = Colors.redAccent;
        } else if (b.health == 2) {
          paint.color = Colors.orangeAccent;
        } else {
          paint.color = Colors.greenAccent;
        }
        final rect = Rect.fromLTWH(left, top, blockWidth, blockHeight);
        canvas.drawRect(rect, paint);
      }
    }
    // Paddle
    final rect = Rect.fromCenter(
      center: paddleCenter,
      width: paddleWidth,
      height: paddleHeight,
    );
    canvas.drawRect(rect, paint);
    // Ball
    canvas.drawCircle(ballPos, ballRadius, paint);

    // Game area boundary line (visible separator for debugging)
    final boundaryPaint = Paint()
      ..color = Colors.cyan.withOpacity(0.3)
      ..strokeWidth = 2;
    canvas.drawLine(
      Offset(0, 135), // Just below HUD area with proper margin
      Offset(size.width, 135),
      boundaryPaint,
    );
    
    // Block area start indicator (temporary debug)
    final blockAreaPaint = Paint()
      ..color = Colors.red.withOpacity(0.5)
      ..strokeWidth = 3;
    canvas.drawLine(
      Offset(0, 140.0), // Shows where blocks actually start (matches topMargin value)
      Offset(size.width, 140.0),
      blockAreaPaint,
    );

    // Debug trajectory line
    if (showDebug && ballVel != null && ballVel!.distance > 0) {
      final debugPaint = Paint()
        ..color = Colors.greenAccent.withOpacity(0.7)
        ..strokeWidth = 2;
      canvas.drawLine(
          ballPos, ballPos + ballVel!.normalized() * 40, debugPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
