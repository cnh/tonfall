package tonfall.format.pcm
{
	import tonfall.format.AudioDecoder;
	import tonfall.format.IAudioIOStrategy;

	import flash.utils.ByteArray;

	/**
	 * @author Andre Michelle
	 */
	public class PCM16BitStereo44Khz
		implements IAudioIOStrategy
	{
		public function readData( decoder: AudioDecoder, target : ByteArray, length : Number, startPosition : Number ) : void
		{
			const bytes: ByteArray = decoder.bytes;

			bytes.position = decoder.dataOffset + ( startPosition << 2 );
			
			for ( var i : int = 0 ; i < length ; ++i )
			{
				target.writeFloat( bytes.readShort() * 3.051850947600e-05 ); // DIV 0x7FFF
				target.writeFloat( bytes.readShort() * 3.051850947600e-05 ); // DIV 0x7FFF
			}
		}
		
		public function write32BitStereo44KHz( data : ByteArray, target: ByteArray, numSamples : uint ) : void
		{
			for ( var i : int = 0 ; i < numSamples ; ++i )
			{
				const left : Number = data.readFloat();
				
				if( left > 1.0 )
					target.writeShort( 0x7FFF );
				else
				if( left < -1.0 )
					target.writeShort( -0x7FFF );
				else
					target.writeShort( left * 0x7FFF );

				const right : Number = data.readFloat();
				
				if( right > 1.0 )
					target.writeShort( 0x7FFF );
				else
				if( right < -1.0 )
					target.writeShort( -0x7FFF );
				else
					target.writeShort( right * 0x7FFF );
			}
		}
		
		public function get blockAlign() : uint
		{
			return 4;
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