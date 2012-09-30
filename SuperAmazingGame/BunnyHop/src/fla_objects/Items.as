package  
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Sarah Chan
	 */
	public class Items extends MovieClip
	{
		var canGet:Boolean = true;
		
		public function Items() {
	
		}
		
		//"removes" item from stage by disabling it
		public function disappearItem():void {
			this.visible = false;
			canGet = false;
		}
		
		//Returns if the item is enabled or not
		public function isEnabled():Boolean {
			return canGet;
		}
	}

}