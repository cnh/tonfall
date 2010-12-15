package tonfall.format.pcm
{
	import flash.utils.Endian;
	import tonfall.format.AudioDecoder;
	import tonfall.format.IAudioIOStrategy;

	import flash.utils.ByteArray;

	/**
	 * @author Andre Michelle
	 */
	public class PCM24BitMono44Khz
		implements IAudioIOStrategy
	{
		private static const bytes: ByteArray = createByteArray();

		private static function createByteArray(): ByteArray
		{
			const bytes: ByteArray = new ByteArray();
			
			bytes.endian = Endian.LITTLE_ENDIAN;
			bytes.length = 4;
			
			return bytes;
		}

		public function readData( decoder: AudioDecoder, target : ByteArray, length : Number, startPosition : Number ) : void
		{
			const bytes: ByteArray = decoder.bytes;

			bytes.position = decoder.dataOffset + startPosition * 3;
			
			for ( var i : int = 0 ; i < length ; ++i )
			{
				const amplitude: Number = int( ( bytes.readUnsignedByte() << 8 | bytes.readUnsignedByte() << 16 | bytes.readUnsignedByte() << 24 ) ) * 0.000000000465661; // DIV 2147483648

				target.writeFloat( amplitude );
				target.writeFloat( amplitude );
			}
		}

		public function write32BitStereo44KHz( data : ByteArray, target: ByteArray, numSamples : uint ) : void
		{
			for ( var i : int = 0 ; i < numSamples ; ++i )
			{
				const amplitude : Number = ( data.readFloat() + data.readFloat() ) * 0.5;
				
				bytes.position = 0;
				
				if( amplitude > 1.0 )
					bytes.writeInt( 0x7FFFFFFF );
				else
				if( amplitude < -1.0 )
					bytes.writeInt( 0x80000000 );
				else
					bytes.writeInt( amplitude * 0x80000000 );

				target.writeBytes( bytes, 1, 3 );
			}
		}
		
		public function get blockAlign() : uint
		{
			return 3;
		}

		public function readableFor( decoder: AudioDecoder ): Boolean
		{
			// No proper check possible
			return true;
		}

		public function writeFormatTag( bytes: ByteArray ): void
		{
			// No Header
		}
	}
}
