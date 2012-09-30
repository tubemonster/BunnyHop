package Bunny 
{
	import flash.events.Event;
	/**
	 * Mask that checks for bunny's collision with ground objects
	 * @author Sarah Chan
	 */
	public class GroundMask extends BunnyGroundMask
	{
		
		var bunny:BunnyMC;
		var groundArr:Array;
		var gObsArr:Array;
		
		var xMC:int = 8; //distance away from MC's x
		var yMC:int = 50; //distance from the MC's y
		
		public function GroundMask(mc:BunnyMC, gArr:Array, ogArr:Array) {
			this.x = mc.x+xMC;
			this.y = mc.y+yMC;
			bunny = mc;
			groundArr = gArr;
			gObsArr = ogArr;
			visible = false;
			this.addEventListener(Event.ENTER_FRAME, step);
		}
		
		/* Moves the mask along with the Bunny object
		 * */
		public function step(e:Event):void {
			this.x = bunny.x+xMC;
			this.y = bunny.y+yMC;
		}
		
		/* Checks if the mask is colliding with a ground object
		 * If it is, return true
		 */
		public function checkLand():Boolean {
			var i:int = 0;
			for (i = 0; i < groundArr.length; i++) {
				if(groundArr[i] !=null){
					if (this.hitTestObject(groundArr[i])) {
					//	trace("Landed at " + this.y + "!");
						return true;
					}		
				}
			}
			return false;
		}
		
		public function checkHit():Boolean {
			var i:int = 0;
			for (i = 0; i < gObsArr.length; i++) {
				if (this.hitTestObject(gObsArr[i])) {
				//	trace("Landed at " + this.y + "!");
					return true;
				}		
			}
			return false;
			
		}
		
		public function groundPushY():int {
			var i:int = 0;
			for (i = 0; i < groundArr.length; i++) {
				if (this.hitTestObject(groundArr[i])) {
				//	trace("Landed at " + this.y + "!");
					return groundArr[i].y -(groundArr[i].height / 2);
				}		
			}
			return 0;
		}
		
		public function changeArr(gArr:Array, ogArr:Array) :void {
			groundArr = gArr;
			gObsArr = ogArr;
		}
		
	}

}