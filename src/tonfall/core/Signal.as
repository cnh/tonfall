package tonfall.core
{
	/**
	 * Stereo audio data linked list item
	 * 
	 * @author Andre Michelle
	 */
	public final class Signal
	{
		public var l: Number; // LEFT CHANNEL
		public var r: Number; // RIGHT CHANNEL

		public var next: Signal; // NEXT POINTER
	}
}
