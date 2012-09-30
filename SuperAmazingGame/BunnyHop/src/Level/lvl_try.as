

package  Level
{
	/**
	 * ...
	 * @author Sarah Chan
	 */
	
	import Bunny.*;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import Ground.*;
	import GroundObstacles.*;
	import Obstacles.*;
	import flash.events.KeyboardEvent;
	
	public class lvl_try
	{
		var groundArr:Array = new Array(); //Array of ground objects
		var obsArr:Array = new Array(); //Array of obstacle objects
		var gObsArr:Array = new Array(); //Array of ground obstacle objects
		
		var loadStage:Stage;
		
		//starting point for bunny
		var bunnyX:int = 100;
		var bunnyY:int = 200;
		
		var stageSpd:int = 12;
		
		var stgWidth:int = 0;
		
		public function lvl_try(ldStg:Stage) {
			loadStage = ldStg;
			loadStage.addEventListener(Event.ENTER_FRAME, moveStg);
		}
		
		public function buildStg():void{
			var i:int = 0;
			var y:int = 532;
			for (i = 64; i < loadStage.stageWidth + 256; i+= 128){
				var ground:GroundObj = new GroundObj(i, y);
				groundArr.push(ground);
				loadStage.addChild(ground);
				stgWidth += 128;
				//y -= 16;
			}
			
			var obs1:TreeTrunk = new TreeTrunk(480, 420)
			loadStage.addChild(obs1);
			obsArr.push(obs1);
			
			var obs2:TreeTrunk = new TreeTrunk(840, 420)
			loadStage.addChild(obs2);
			obsArr.push(obs2);
			
			//Set the obstacle masks for the obstacle list
			for (i = 0; i < obsArr.length; i++) {
				var obs1_top:TreeTopMask = obsArr[i].createMask();
				loadStage.addChild(obs1_top);
				groundArr.push(obs1_top);	
			}
			
			
			
			var gObs1:Hole = new Hole(320, y);
			gObsArr.push(gObs1);
			loadStage.addChild(gObs1);
			
		}
		
		public function groundObjArray():Array {
			return groundArr;
		}
		
		public function groundObsObjArray():Array {
			return gObsArr
		}
		
		public function obsObjArray():Array {
			return obsArr;
		}
		
		public function moveStg(e:Event):void {
			var i:int = 0;
			for (i = 0; i < groundArr.length; i++) {
				groundArr[i].x -= stageSpd;
				if ((groundArr[i].x < -(groundArr[i].width / 2)))
					groundArr[i].x += stgWidth;
			}
			for (i = 0; i < obsArr.length; i++) {
				obsArr[i].x -= stageSpd;
				if ((obsArr[i].x < -(obsArr[i].width / 2)))
					obsArr[i].x += stgWidth;
			}
			for (i = 0; i < gObsArr.length; i++) {
				gObsArr[i].x -= stageSpd;
				if ((gObsArr[i].x < -(gObsArr[i].width / 2)))
					gObsArr[i].x += stgWidth;
			}
		}
		
		public function removeStgObj():void {
			var i:int = 0;
			for (i = 0; i < groundArr.length; i++) {
				loadStage.removeChild(groundArr[i]);
			}
			for (i = 0; i < obsArr.length; i++) {
				loadStage.removeChild(obsArr[i]);
			}
			for (i = 0; i < gObsArr.length; i++) {
				loadStage.removeChild(obsArr[i]);
			}
			
		}
		
	}

}