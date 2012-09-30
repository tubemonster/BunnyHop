package Bunny 
{
	import flash.events.Event;
	/**
	 * Mask that checks for bunny's collision with ground objects
	 * @author Sarah Chan
	 */
	public class FrontMask extends BunnyFrontMask
	{
		
		var bunny:BunnyMC;
		var obsArr:Array;
		var itemArr:Array;
		
		var xMC:int = 14; //distance away from MC's x
		var yMC:int = 0; //distance from the MC's y
		
		public function FrontMask(mc:BunnyMC, oArr:Array, iArr:Array) {
			this.x = mc.x+xMC;
			this.y = mc.y+yMC;
			bunny = mc;
			obsArr = oArr;
			itemArr = iArr;
			visible = false;
			this.addEventListener(Event.ENTER_FRAME, step);
		}
		
		/* Moves the mask along with the Bunny object
		 * */
		public function step(e:Event):void {
			this.x = bunny.x+xMC;
			this.y = bunny.y+yMC;
		}
		
		/* Checks if the mask is colliding with an obstacle object
		 * If it is, return true
		 */
		public function checkHit():Boolean {
			var i:int = 0;
			for (i = 0; i < obsArr.length; i++) {
				if (this.hitTestObject(obsArr[i])) {
				//	trace("Landed at " + this.y + "!");
					return true;
				}		
			}
			return false;	
		}
		
		/* Checks if the mask is colliding with an item object
		 * If it is, return true
		 */
		public function checkGetItem():Boolean {
			var i:int = 0;
			for (i = 0; i < itemArr.length; i++) {
				if (this.hitTestObject(itemArr[i])) {
					if(itemArr[i].isEnabled()){
						itemArr[i].disappearItem();
						return true;
					}
				}		
			}
			return false;	
		}
		
		public function changeArr(oArr:Array, iArr:Array) :void {
			itemArr = iArr;
			obsArr = oArr;
		}
		
		
	}

}