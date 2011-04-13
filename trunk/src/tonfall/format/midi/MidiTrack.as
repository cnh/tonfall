package tonfall.format.midi 
	import flash.utils.ByteArray;
	{
		public const channels: Vector.<Vector.<MidiChannelEvent>> = new Vector.<Vector.<MidiChannelEvent>>( 16, true );
		private var _index: int;

		public function MidiTrack( index: int )
		{
			_index = index;
			init();
		}
		{
			var event: MidiEvent;
			
			var deltaTime: Number;
			
			var byte: int;
			var lastByte: int = 0;
			
			for(; ;)
			{
				deltaTime = readVarLen( stream );
				
				byte = stream.readUnsignedByte( );
				
				if( byte < 0xF0 ) // 0x00....0xEF
				{
					{
						--stream.position;
						event = new MidiChannelEvent( absoluteTime / timeDivision );
						MidiChannelEvent( event ).decode( stream, lastByte );
					}
					else
					{
						event = new MidiChannelEvent( absoluteTime / timeDivision );
						MidiChannelEvent( event ).decode( stream, byte );
						
						lastByte = byte;
					}
						channels[ MidiChannelEvent( event ).channelNum ].push( event );
				else if( byte < 0xF8 ) // 0xF0....0xF7
				{
					throw new Error( 'SysEx is not supported yet.' );
				}
				else // 0xF8....0xFF
				{
					event = new MidiMetaEvent( absoluteTime / timeDivision );
					MidiMetaEvent( event ).decode( stream );

					if( MidiMetaEvent( event ).type == MidiMetaEvent.END_OF_TRACK )
						break;
				}
			}

}