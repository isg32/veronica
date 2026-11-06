import '../data/models/models.dart';
import '../data/repositories/repositories.dart';
import 'glyph_mock.dart';
import 'mock_cell.dart';

/// af_heart at 1.0×, all moments on, model downloaded, every line rendered.
const VoiceSettings mockVoiceSettings = VoiceSettings();

/// Voice and Glyph settings.
class MockSettingsRepository implements SettingsRepository {
  final MockCell<VoiceSettings> _voice = MockCell(mockVoiceSettings);
  final MockCell<GlyphSettings> _glyph = MockCell(mockGlyphSettings);

  @override
  Stream<VoiceSettings> watchVoice() => _voice.watch();

  @override
  Future<void> saveVoice(VoiceSettings settings) async =>
      _voice.value = settings;

  @override
  Stream<GlyphSettings> watchGlyph() => _glyph.watch();

  @override
  Future<void> saveGlyph(GlyphSettings settings) async =>
      _glyph.value = settings;
}
