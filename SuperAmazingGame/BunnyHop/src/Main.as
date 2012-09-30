package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import Bunny.BunnyMC;
	import flash.events.MouseEvent;
	import Ground.*;
	import GroundObstacles.*;
	import Level.*;
	import Menu.*;
	import Obstacles.*;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.display.Loader;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.engine.*;
	
	/**
	 * ...
	 * @author Sarah Chan
	 */
	public class Main extends Sprite 
	{
		[Embed (source = "../lib/background.png")]
		[Bindable]
		public var bg_img:Class;
		var start:StartButton
		var retry:RetryButton = new RetryButton(350, 200);
		var textLine1:TextLine; //instructions for the menu
		
		var pntDisplay:TextField //display the points
		
		var groundArr:Array; //Array of ground objects
		var obsArr:Array; //Array of obstacle objects
		var gObsArr:Array; //Array of ground obstacle objects
		var itemArr:Array;//Array of item objects
		
		var lvl:Level.Level;
		var nextLvl:Level.Level;
		var loader:URLLoader;
		public var data:XML;
		public var loadStage:Stage;
		
		var mc:Bunny.BunnyMC;
		var pnts:int = 0;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			start = new StartButton(350, 200);
			stage.addChild(start);
			
			var format:ElementFormat = new ElementFormat();
			format.fontSize = 20;
            var textElement:TextElement = new TextElement("Press Z to jump! Press Z again to double jump! Press X to stomp down!", format); 
            var textBlock:TextBlock = new TextBlock(); 
            textBlock.content = textElement; 
             
            textLine1 = textBlock.createTextLine(null, 600); 
			TextBaseline:
            stage.addChild(textLine1); 
            textLine1.x = 100; 
            textLine1.y = 100; 
			
			start.addEventListener(MouseEvent.MOUSE_UP, startStg);
		}
		
		
		public function startStg(e:MouseEvent):void {
			
			//Create the background image
			stage.addChild(new bg_img());
			
			loader = new URLLoader(new URLRequest("LevelXMLSoFarNeedToAddWaterWatDoYouThink.xml")) //Create a new loader for the level file
			loader.addEventListener(Event.COMPLETE, dataLoaded); //Add the rest of the stage once the data is loaded
			
			stage.removeChild(start);
			start.removeEventListener(MouseEvent.MOUSE_UP, startStg);
			start = null;
			stage.removeChild(textLine1);
		}
		
		public function restartStg(e:MouseEvent):void {
		
			stage.removeChild(retry);
			retry.removeEventListener(MouseEvent.MOUSE_UP, restartStg);
			
			lvl = new Level.Level(this.stage, 0, data, 0);
			nextLvl = new Level.Level(this.stage, lvl.lengthOfStg(), data, 0);
			setUpArr();
			
			stage.addChild(mc);
			mc.x = 100;
			mc.y = 200;
			mc.resetVar();
			mc.setMasks(groundArr, obsArr, gObsArr, itemArr);
			mc.addEventListener(Event.ENTER_FRAME, mc.movement);
			mc.addEventListener(Event.REMOVED_FROM_STAGE, mc.rmvFromStg);
			
			mc.addPts( -mc.getPts());
			
			this.addEventListener(Event.ENTER_FRAME, runStg);
		}
	
		/*Build the levels when the XML data is loaded*/
		public function dataLoaded(e:Event):void{
			data = new XML(e.target.data);
			//Set up the stage levels
			this.addEventListener(Event.ENTER_FRAME, runStg);
            lvl = new Level.Level(this.stage, 0, data, 0);
			nextLvl = new Level.Level(this.stage, lvl.lengthOfStg(), data, 0);
			setUpArr();
	
			//Add the bunny object on stage and set up its events and masks
			mc = new Bunny.BunnyMC(100, 200);
			mc.scaleX = 0.5;
			mc.scaleY = 0.5;
			stage.addChild(mc);
			mc.setMasks(groundArr, obsArr, gObsArr, itemArr);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, mc.KeyDown);
			
			var pntFormat:TextFormat = new TextFormat();
			pntFormat.size = 20;
			
			//Add the points counter
			var pntFormat:TextFormat = new TextFormat();
			pntFormat.size = 24;

			pntDisplay = new TextField();
			pntDisplay.defaultTextFormat = pntFormat;
			pntDisplay.text = "Points: " + mc.getPts().toString();
			stage.addChild(pntDisplay);
			pntDisplay.width = 250;
			pntDisplay.x = 16;
			pntDisplay.y = 8;
			
		}
		
		//Set the object arrays to contain both lvl and nextlvl objects
		public function setUpArr():void {
			var i:int;
			
			groundArr = new Array();
			for (i = 0; i < lvl.groundObjArray().length; i++)
				groundArr.push(lvl.groundObjArray()[i]);
			for (i = 0; i < nextLvl.groundObjArray().length; i++)
				groundArr.push(nextLvl.groundObjArray()[i]);
			
			gObsArr = new Array();
			for (i = 0; i < lvl.groundObsObjArray().length; i++)
				gObsArr.push(lvl.groundObsObjArray()[i]);
			for (i = 0; i < nextLvl.groundObsObjArray().length; i++)
				gObsArr.push(nextLvl.groundObsObjArray()[i]);
				
			obsArr = new Array();
			for (i = 0; i < lvl.obsObjArray().length; i++)
				obsArr.push(lvl.obsObjArray()[i]);
			for (i = 0; i < nextLvl.obsObjArray().length; i++)
				obsArr.push(nextLvl.obsObjArray()[i]);
				
			itemArr = new Array();
			for (i = 0; i < lvl.itemObjArray().length; i++)
				itemArr.push(lvl.itemObjArray()[i]);
			for (i = 0; i < nextLvl.itemObjArray().length; i++)
				itemArr.push(nextLvl.itemObjArray()[i]);
			
		}
		
		public function runStg(e:Event):void {
			
			//Check if the current stage is finished and loads a new stage
			if (lvl.stgRun() <= -lvl.lengthOfStg()) {
				var disBtwnStg:int = lvl.stgRun() + lvl.lengthOfStg();
				var removeLvl:Level.Level = lvl;
				lvl = nextLvl;
				
				var high:int = 4;
				var low: int = 1;
				var lvlNum:int = Math.floor(Math.random()*(1+high-low))+low; //Generate a random level
				
				nextLvl = new Level.Level(this.stage, lvl.lengthOfStg() + disBtwnStg, data, 0);
				setUpArr();
				mc.changeArr(groundArr, obsArr, gObsArr, itemArr);
				removeLvl.removeStgObj(); //Remove the objects that are no longer used
				
				stage.setChildIndex(mc, stage.numChildren - 1); //Bring the mc to the front
				stage.setChildIndex(pntDisplay, stage.numChildren - 1); //Bring the points display to the front
			}
			
			mc.addPts(1);
			
			//Update the points display
			if (mc.getPts() != pnts) {
				pnts = mc.getPts();
				pntDisplay.text = "Points: " + mc.getPts().toString();
			}
			
			if (mc.checkLose()) {
				//mc.addPts( -mc.getPts());
				trace("LOSE");
				stage.removeChild(mc);
				this.removeEventListener(Event.ENTER_FRAME, runStg);
				lvl.removeStgObj();
				nextLvl.removeStgObj();
				
				stage.addChild(retry);
				retry.addEventListener(MouseEvent.MOUSE_UP, restartStg);
			}
			
		}
		
	}
	
}