package Ground 
{
	import flash.events.Event;
	import Level.Level;
	/**
	 * ...
	 * @author Sarah Chan
	 */
	public class LilypadObj extends LilypadMask
	{
		var lilypad:Lilypad;
		public function LilypadObj(x:int, y:int) {
			this.x = x;
			this.y = y;
			this.addEventListener(Event.ADDED_TO_STAGE, addImg);
		}
		
		public function addImg(e:Event):void {
			lilypad = new Lilypad();
			lilypad.x = this.x;
			lilypad.y = this.y;
			//lilypad.visible = false;
			this.parent.addChild(lilypad);
			this.removeEventListener(Event.ADDED_TO_STAGE, addImg);
			this.addEventListener(Event.ENTER_FRAME, imgFollow);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removeImg);
		}
		
		public function removeImg(e:Event):void {
			this.parent.removeChild(lilypad);
			this.removeEventListener(Event.ENTER_FRAME, imgFollow);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, removeImg);
		}
		
		public function imgFollow(e:Event):void {
			lilypad.x = this.x;
			lilypad.y = this.y;
		}
		
	}

}