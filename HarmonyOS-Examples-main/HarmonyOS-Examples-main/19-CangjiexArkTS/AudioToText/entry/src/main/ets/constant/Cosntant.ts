import { speechRecognizer } from '@kit.CoreSpeechKit';
import { audio } from '@kit.AudioKit';

export class Constants {

  private static AUDIO_STREAM_INFO = {
    samplingRate: audio.AudioSamplingRate.SAMPLE_RATE_16000,
    channels: audio.AudioChannel.CHANNEL_1,
    sampleFormat: audio.AudioSampleFormat.SAMPLE_FORMAT_S16LE,
    encodingType: audio.AudioEncodingType.ENCODING_TYPE_RAW
  };

  private static AUDIO_CAPTURER_INFO = {
    source: audio.SourceType.SOURCE_TYPE_MIC,
    capturerFlags: 0
  };

  public static AUDIO_CAPTURER_OPTIONS = {
    streamInfo: Constants.AUDIO_STREAM_INFO,
    capturerInfo: Constants.AUDIO_CAPTURER_INFO
  };


  public static audioParam: speechRecognizer.AudioInfo = {
    audioType: 'pcm',
    sampleRate: 16000,
    soundChannel: 1,
    sampleBit: 16
  }

  public static extraParam: Record<string, Object> = {
    "recognitionMode": 0,
    "vadBegin": 2000,
    "vadEnd": 3000,
    "maxAudioDuration": 20000
  }

  public static recognizerParams: speechRecognizer.StartParams = {
    sessionId: "123456",
    audioInfo: Constants.audioParam,
    extraParams: Constants.extraParam
  }

  public static supportedAudioTypes: Array<string> = [".pcm", ".wav", ".mp3", ".aac"];
}