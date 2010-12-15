package tonfall.format.wav
{
	import tonfall.format.AbstractAudioDecoder;
	import tonfall.format.IAudioIOStrategy;
	import tonfall.format.pcm.PCM8BitStereo44Khz;

	/**
	 * @author Andre Michelle
	 */
	public final class WAV8BitStereo44Khz extends PCM8BitStereo44Khz
		implements IAudioIOStrategy
	{
		public static const INSTANCE: IAudioIOStrategy = new WAV8BitStereo44Khz();

		public function WAV8BitStereo44Khz()
		{
			super( false );
		}
		
		override public function readableFor( decoder: AbstractAudioDecoder ) : Boolean
		{
			return 1 == decoder.compressionType && 8 == decoder.bits && 2 == decoder.numChannels && 44100 == decoder.samplingRate;
		}
		
		override public function get compressionType(): *
		{
			return 1;
		}
	}
}