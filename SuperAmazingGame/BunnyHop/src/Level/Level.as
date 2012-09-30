package Level 
{
	
	import Bunny.*;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	import Ground.*;
	import GroundObstacles.*;
	import Obstacles.*;
	import Item.*;
	import flash.events.KeyboardEvent;
	
	/**
	 * ...
	 * @author Sarah Chan
	 */
	public class Level 
	{
		
		var groundArr:Array = new Array(); //Array of ground objects
		var obsArr:Array = new Array(); //Array of obstacle objects
		var gObsArr:Array = new Array(); //Array of ground obstacle objects
		var itemArr:Array = new Array(); //Array of item objects
		var groundArrOverlap:Array = new Array();
		
		var loadStage:Stage;
		
		//starting point for bunny
		var bunnyX:int = 100;
		var bunnyY:int = 200;
		
		//stage properties
		var stageSpd:int = 14; //speed the stage is moving in
		var stgWidth:int = 0; //length of the stage
		var stgX:int = 0; //where the start of stage is located
		
		//stage starting point
		var stageStartX:int = 0;
		
		var data:XML;
		
		public function Level(ldStg:Stage, startX:int, lvlData:XML, lvlIndex:int ) {
			loadStage = ldStg;
			this.stageStartX = startX;
			data = lvlData;
			buildStg(lvlIndex);
			shiftStg();
			addToStg();
			loadStage.addEventListener(Event.ENTER_FRAME, moveStg);
		}
		
		public function moveStg(e:Event):void {
			var i:int = 0;
			for (i = 0; i < groundArr.length; i++) {
				groundArr[i].x -= stageSpd;
			}
			for (i = 0; i < obsArr.length; i++) {
				obsArr[i].x -= stageSpd;
			}
			for (i = 0; i < gObsArr.length; i++) {
				gObsArr[i].x -= stageSpd;
			}
			for (i = 0; i < itemArr.length; i++) {
				itemArr[i].x -= stageSpd;
			}
			for (i = 0; i < groundArrOverlap.length; i++) {
				groundArrOverlap[i].x -= stageSpd;
			}
			stgX -= stageSpd;
		}
		
		/*Shifts the stage right to the stage starting point*/
		public function shiftStg():void {
			var i:int = 0;
			for (i = 0; i < groundArr.length; i++) {
				groundArr[i].x += stageStartX;
			}
			for (i = 0; i < obsArr.length; i++) {
				obsArr[i].x += stageStartX;
			}
			for (i = 0; i < gObsArr.length; i++) {
				gObsArr[i].x += stageStartX;
			}
			for (i = 0; i < itemArr.length; i++) {
				itemArr[i].x += stageStartX;
			}
			for (i = 0; i < groundArrOverlap.length; i++) {
				groundArrOverlap[i].x += stageStartX;
			}
			stgX += stageStartX;
		}
		
		/*Set up stage according to the data from the XML file
		 * 
		 * */
		public function buildStg(level:int):void {

			var xmlW:XML = data.levels.children()[level];
			
			stgWidth = xmlW.@width;
			for (var i:String in data.levels.children()[level].groundObjs.children())
			{
				//Adding ground objects into the ground object array
				var groundObjs:XML = data.levels.children()[level].groundObjs.children()[i];
				if (groundObjs.@type == "ground"){
					var gnd:GroundObj = new GroundObj(groundObjs.@x, groundObjs.@y);
					groundArr.push(gnd);
				}
				/*else if (groundObjs.@type == "water"){
					var water:WaterGroundObj = new WaterGroundObj(groundObjs.@x, groundObjs.@y);
					groundArr.push(water);
					
				}*/
			}
			
			for (var i:String in data.levels.children()[level].groundObsObjs.children())
			{
				//Adding ground objects into the ground object array
				var groundObsObjs:XML = data.levels.children()[level].groundObsObjs.children()[i];
				if (groundObsObjs.@type == "hole"){
					var gndObs:Hole = new Hole(groundObsObjs.@x, groundObsObjs.@y);
					gObsArr.push(gndObs);
				}
				else if (groundObsObjs.@type == "water_obstacle") {
					var water:WaterGroundObj = new WaterGroundObj(groundObsObjs.@x, groundObsObjs.@y);
					groundArr.push(water);
					var waterObs:WaterObj = new WaterObj(groundObsObjs.@x, groundObsObjs.@y);
					gObsArr.push(waterObs);
				}
			}
			
			for (var i:String in data.levels.children()[level].obsObjs.children())
			{
				//Adding ground objects into the ground object array
				var obsObjs:XML = data.levels.children()[level].obsObjs.children()[i];
				if (obsObjs.@type == "tree_trunk"){
					var treeObs:TreeTrunk = new TreeTrunk(obsObjs.@x, obsObjs.@y);
					obsArr.push(treeObs);
					//Create a landing mask for the ground array
					var obs1_top:TreeTopMask = treeObs.createMask();
					groundArr.push(obs1_top);
				}
			}
			
			for (var i:String in data.levels.children()[level].itemObjs.children())
			{
				//Adding ground objects into the ground object array
				var itemObjs:XML = data.levels.children()[level].itemObjs.children()[i];
				if (itemObjs.@type == "carrot") {
					var carrot:CarrotItem = new CarrotItem(itemObjs.@x, itemObjs.@y);
					itemArr.push(carrot);
				}
			}
		}
		
		public function groundObjArray():Array {
			var gArr:Array = new Array();
			var i:int = 0;
			for (i = 0; i < groundArr.length; i++)
				gArr.push(groundArr[i]);
			for (i = 0; i < groundArrOverlap.length; i++)
				gArr.push(groundArrOverlap[i]);
			return gArr;
		}
		
		public function groundObsObjArray():Array {
			return gObsArr;
		}
		
		public function obsObjArray():Array {
			return obsArr;
		}
		
		public function itemObjArray():Array {
			return itemArr;
		}
		
		public function lengthOfStg():int {
			return stgWidth;
		}
		
		public function stgRun():int {
			return stgX;
		}
		
		//Remove all the objects that are on stage
		public function removeStgObj():void {
			var i:int = 0;
			for (i = 0; i < groundArr.length; i++) {
				if (loadStage.contains(groundArr[i])){
					loadStage.removeChild(groundArr[i]);
					groundArr[i] = null;
				}
			}
			for (i = 0; i < obsArr.length; i++) {
				if (loadStage.contains(obsArr[i]))
					loadStage.removeChild(obsArr[i]);
					obsArr[i] = null;
			}
			for (i = 0; i < gObsArr.length; i++) {
				if (loadStage.contains(gObsArr[i]))
					loadStage.removeChild(gObsArr[i]);
					gObsArr[i] = null;
			}
			for (i = 0; i < itemArr.length; i++) {
				if (loadStage.contains(itemArr[i]))
					loadStage.removeChild(itemArr[i]);
					itemArr[i] = null;
			}
			for (i = 0; i < groundArrOverlap.length; i++) {
				if (loadStage.contains(groundArrOverlap[i])){
					loadStage.removeChild(groundArrOverlap[i]);
					groundArrOverlap[i] = null;
				}
			}
			
			loadStage.removeEventListener(Event.ENTER_FRAME, moveStg);
		}
		
		public function addToStg():void {
			var i:int = 0;
			for (i = 0; i < groundArr.length; i++) {
				loadStage.addChild(groundArr[i])
			}
			for (i = 0; i < obsArr.length; i++) {
				loadStage.addChild(obsArr[i])
			}
			for (i = 0; i < gObsArr.length; i++) {
				loadStage.addChild(gObsArr[i])
			}
			for (i = 0; i < itemArr.length; i++) {
				loadStage.addChild(itemArr[i])
			}
			for (i = 0; i < groundArrOverlap.length; i++) {
				loadStage.addChild(groundArrOverlap[i])
			}
		}
	}

}