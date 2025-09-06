import 'package:flutter/material.dart';

typedef SensitivityCallback = void Function(double value);

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16, bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.lightBlue, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PresetButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _PresetButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  final double initialSensitivity;
  final SensitivityCallback onChanged;
  final double initialSensitivityMultiplier;
  final SensitivityCallback onSensitivityMultiplierChanged;
  final double initialControlCurve;
  final SensitivityCallback onControlCurveChanged;
  final bool initialSoundEnabled;
  final bool initialHapticsEnabled;
  final void Function(bool) onSoundChanged;
  final void Function(bool) onHapticsChanged;
  final double initialVolume;
  final void Function(double) onVolumeChanged;
  final double initialHitMultiplier;
  final double initialGameOverMultiplier;
  final void Function(double) onHitMultiplierChanged;
  final void Function(double) onGameOverMultiplierChanged;
  // Control tuning
  final double initialDeadzone;
  final void Function(double) onDeadzoneChanged;
  final double initialResponsiveness;
  final void Function(double) onResponsivenessChanged;
  final double initialMomentum;
  final void Function(double) onMomentumChanged;
  final void Function(String) onPresetSelected;
  final VoidCallback onCalibrate;
  const SettingsPage({
    Key? key,
    required this.initialSensitivity,
    required this.onChanged,
    required this.initialSensitivityMultiplier,
    required this.onSensitivityMultiplierChanged,
    required this.initialControlCurve,
    required this.onControlCurveChanged,
    this.initialSoundEnabled = true,
    this.initialHapticsEnabled = true,
    required this.onSoundChanged,
    required this.onHapticsChanged,
    this.initialVolume = 1.0,
    required this.onVolumeChanged,
    this.initialHitMultiplier = 0.9,
    this.initialGameOverMultiplier = 1.0,
    required this.onHitMultiplierChanged,
    required this.onGameOverMultiplierChanged,
    this.initialDeadzone = 0.05,
    required this.onDeadzoneChanged,
    this.initialResponsiveness = 0.95,
    required this.onResponsivenessChanged,
    this.initialMomentum = 0.1,
    required this.onMomentumChanged,
    required this.onPresetSelected,
    required this.onCalibrate,
  }) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late double _value;
  late double _sensitivityMultiplier;
  late double _controlCurve;
  bool _showPreview = false;
  late bool _soundEnabled;
  late bool _hapticsEnabled;
  late double _volume;
  late double _hitMultiplier;
  late double _gameOverMultiplier;
  late double _deadzone;
  late double _responsiveness;
  late double _momentum;

  @override
  void initState() {
    super.initState();
    _value = widget.initialSensitivity;
    _sensitivityMultiplier = widget.initialSensitivityMultiplier;
    _controlCurve = widget.initialControlCurve;
    _soundEnabled = widget.initialSoundEnabled;
    _hapticsEnabled = widget.initialHapticsEnabled;
    _volume = widget.initialVolume;
    _hitMultiplier = widget.initialHitMultiplier;
    _gameOverMultiplier = widget.initialGameOverMultiplier;
    _deadzone = widget.initialDeadzone;
    _responsiveness = widget.initialResponsiveness;
    _momentum = widget.initialMomentum;
    // Restore defaults action
  }

  void _restoreDefaults() {
    // save previous values so we can undo
    final prevSensitivity = _value;
    final prevSound = _soundEnabled;
    final prevHaptics = _hapticsEnabled;
    final prevVolume = _volume;
    final prevHit = _hitMultiplier;
    final prevGameOver = _gameOverMultiplier;

    const double defaultSensitivity = 350.0;
    const bool defaultSound = true;
    const bool defaultHaptics = true;
    const double defaultVolume = 1.0;
    const double defaultHit = 0.9;
    const double defaultGameOver = 1.0;

    setState(() {
      _value = defaultSensitivity;
      _soundEnabled = defaultSound;
      _hapticsEnabled = defaultHaptics;
      _volume = defaultVolume;
      _hitMultiplier = defaultHit;
      _gameOverMultiplier = defaultGameOver;
    });

    // apply and persist via callbacks
    widget.onChanged(_value);
    widget.onSoundChanged(_soundEnabled);
    widget.onHapticsChanged(_hapticsEnabled);
    widget.onVolumeChanged(_volume);
    widget.onHitMultiplierChanged(_hitMultiplier);
    widget.onGameOverMultiplierChanged(_gameOverMultiplier);

    // show undo snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Defaults restored'),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () {
            // restore previous values
            setState(() {
              _value = prevSensitivity;
              _soundEnabled = prevSound;
              _hapticsEnabled = prevHaptics;
              _volume = prevVolume;
              _hitMultiplier = prevHit;
              _gameOverMultiplier = prevGameOver;
            });
            // call callbacks to re-apply and persist
            widget.onChanged(_value);
            widget.onSoundChanged(_soundEnabled);
            widget.onHapticsChanged(_hapticsEnabled);
            widget.onVolumeChanged(_volume);
            widget.onHitMultiplierChanged(_hitMultiplier);
            widget.onGameOverMultiplierChanged(_gameOverMultiplier);
          },
        ),
      ),
    );
  }

  void _confirmRestoreDefaults() async {
    final res = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Restore defaults'),
        content: const Text('Restore all settings to their default values?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Restore'),
          ),
        ],
      ),
    );
    if (res == true) _restoreDefaults();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              tooltip: 'Restore defaults',
              icon: const Icon(Icons.restore, color: Colors.white),
              onPressed: _confirmRestoreDefaults,
            ),
          ),
        ],
        backgroundColor: const Color(0xFF1B263B),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF0D1B2A), Color(0xFF1B263B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            _SectionHeader(
              icon: Icons.tune,
              title: 'Gyro Sensitivity',
              subtitle: 'Adjust paddle responsiveness',
            ),
            const SizedBox(height: 8),
            Slider(
              value: _value,
              min: 20,
              max: 300,
              divisions: 56,
              label: _value.toStringAsFixed(0),
              onChangeStart: (_) => setState(() => _showPreview = true),
              onChangeEnd: (_) => setState(() => _showPreview = false),
              onChanged: (v) {
                setState(() => _value = v);
                widget.onChanged(v);
              },
            ),
            const SizedBox(height: 8),
            Text('${_value.toStringAsFixed(0)}',
                style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 20),
            _SectionHeader(
              icon: Icons.speed,
              title: 'Sensitivity Multiplier',
              subtitle: 'Fine-tune response strength',
            ),
            const SizedBox(height: 8),
            Slider(
              value: _sensitivityMultiplier,
              min: 0.1,
              max: 3.0,
              divisions: 29,
              label: _sensitivityMultiplier.toStringAsFixed(1),
              onChanged: (v) {
                setState(() => _sensitivityMultiplier = v);
                widget.onSensitivityMultiplierChanged(v);
              },
            ),
            const SizedBox(height: 8),
            Text('${_sensitivityMultiplier.toStringAsFixed(1)}x',
                style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 20),
            _SectionHeader(
              icon: Icons.trending_up,
              title: 'Control Curve',
              subtitle: 'Adjust control response curve',
            ),
            const SizedBox(height: 8),
            Slider(
              value: _controlCurve,
              min: 1.0,
              max: 3.0,
              divisions: 20,
              label: _controlCurve.toStringAsFixed(1),
              onChanged: (v) {
                setState(() => _controlCurve = v);
                widget.onControlCurveChanged(v);
              },
            ),
            const SizedBox(height: 8),
            Text('Power: ${_controlCurve.toStringAsFixed(1)}',
                style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 20),
            _SectionHeader(
              icon: Icons.volume_up,
              title: 'Audio & Feedback',
              subtitle: 'Sound and vibration settings',
            ),
            const SizedBox(height: 8),
            const Text('Volume', style: TextStyle(color: Colors.white70)),
            Slider(
              value: _volume,
              min: 0,
              max: 1,
              divisions: 20,
              label: (_volume * 100).toStringAsFixed(0),
              onChanged: (v) {
                setState(() => _volume = v);
                widget.onVolumeChanged(v);
              },
            ),
            const SizedBox(height: 8),
            Text('${(_volume * 100).toStringAsFixed(0)}%',
                style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 12),
            const Text('Per-event Volume',
                style: TextStyle(color: Colors.white, fontSize: 16)),
            const SizedBox(height: 8),
            Text('Hit volume', style: TextStyle(color: Colors.white70)),
            Slider(
              value: _hitMultiplier,
              min: 0,
              max: 1,
              divisions: 20,
              label: (_hitMultiplier * 100).toStringAsFixed(0),
              onChanged: (v) {
                setState(() => _hitMultiplier = v);
                widget.onHitMultiplierChanged(v);
              },
            ),
            const SizedBox(height: 8),
            Text('${(_hitMultiplier * 100).toStringAsFixed(0)}%',
                style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Text('Game-over volume', style: TextStyle(color: Colors.white70)),
            Slider(
              value: _gameOverMultiplier,
              min: 0,
              max: 2,
              divisions: 20,
              label: (_gameOverMultiplier * 100).toStringAsFixed(0),
              onChanged: (v) {
                setState(() => _gameOverMultiplier = v);
                widget.onGameOverMultiplierChanged(v);
              },
            ),
            const SizedBox(height: 8),
            Text('${(_gameOverMultiplier * 100).toStringAsFixed(0)}%',
                style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 12),
            _SectionHeader(
              icon: Icons.gamepad,
              title: 'Control Presets',
              subtitle: 'Quick sensitivity presets',
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _PresetButton(
                  label: 'Low',
                  icon: Icons.speed,
                  color: Colors.green,
                  onPressed: () => widget.onPresetSelected('low'),
                ),
                _PresetButton(
                  label: 'Medium',
                  icon: Icons.whatshot,
                  color: Colors.orange,
                  onPressed: () => widget.onPresetSelected('medium'),
                ),
                _PresetButton(
                  label: 'High',
                  icon: Icons.rocket_launch,
                  color: Colors.red,
                  onPressed: () => widget.onPresetSelected('high'),
                ),
                _PresetButton(
                  label: 'Calibrate',
                  icon: Icons.tune,
                  color: Colors.blue,
                  onPressed: widget.onCalibrate,
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('Deadzone', style: TextStyle(color: Colors.white70)),
            Slider(
              value: _deadzone,
              min: 0,
              max: 1,
              divisions: 20,
              label: (_deadzone * 100).toStringAsFixed(0),
              onChanged: (v) {
                setState(() => _deadzone = v);
                widget.onDeadzoneChanged(v);
              },
            ),
            const SizedBox(height: 8),
            Text('${(_deadzone * 100).toStringAsFixed(0)}%',
                style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 12),
            const Text('Responsiveness', style: TextStyle(color: Colors.white70)),
            Slider(
              value: _responsiveness,
              min: 0.5,
              max: 1.0,
              divisions: 20,
              label: (_responsiveness * 100).toStringAsFixed(0),
              onChanged: (v) {
                setState(() => _responsiveness = v);
                widget.onResponsivenessChanged(v);
              },
            ),
            const SizedBox(height: 8),
            Text('${(_responsiveness * 100).toStringAsFixed(0)}%',
                style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 12),
            const Text('Momentum', style: TextStyle(color: Colors.white70)),
            Slider(
              value: _momentum,
              min: 0.01,
              max: 0.3,
              divisions: 20,
              label: (_momentum * 100).toStringAsFixed(0),
              onChanged: (v) {
                setState(() => _momentum = v);
                widget.onMomentumChanged(v);
              },
            ),
            const SizedBox(height: 8),
            Text('${(_momentum * 100).toStringAsFixed(0)}%',
                style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 12),
            SwitchListTile(
              value: _soundEnabled,
              onChanged: (v) {
                setState(() => _soundEnabled = v);
                widget.onSoundChanged(v);
              },
              title: const Text('Sound', style: TextStyle(color: Colors.white)),
            ),
            SwitchListTile(
              value: _hapticsEnabled,
              onChanged: (v) {
                setState(() => _hapticsEnabled = v);
                widget.onHapticsChanged(v);
              },
              title:
                  const Text('Haptics', style: TextStyle(color: Colors.white)),
            ),
            ],
          ),
        ),
      ),
      // floating preview overlay
      floatingActionButton: _showPreview
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF415A77), Color(0xFF778DA9)],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text('${_value.toStringAsFixed(0)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  )),
            )
          : null,
    );
  }
}
