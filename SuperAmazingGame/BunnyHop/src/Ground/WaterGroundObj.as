package Ground 
{
	/**
	 * ...
	 * @author Sarah Chan
	 */
	
	import flash.events.Event;
	 
	public class WaterGroundObj extends WaterObsMask
	{
		var waterImg:WaterObs;
		
		public function WaterGroundObj(x:int, y:int) {
			this.x = x;
			this.y = y;
			this.addEventListener(Event.ADDED_TO_STAGE, addImg);
		}
		
		public function addImg(e:Event):void {
			waterImg = new WaterObs();
			waterImg.x = this.x;
			waterImg.y = this.y;
			//waterImg.visible = false;
			this.parent.addChild(waterImg);
			this.removeEventListener(Event.ADDED_TO_STAGE, addImg);
			this.addEventListener(Event.ENTER_FRAME, imgFollow);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removeImg);
		}
		
		public function removeImg(e:Event):void {
			this.parent.removeChild(waterImg);
			this.removeEventListener(Event.ENTER_FRAME, imgFollow);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, removeImg);
		}
		
		public function imgFollow(e:Event):void {
			waterImg.x = this.x;
			waterImg.y = this.y;
		}
		
	}

}