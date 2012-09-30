package Bunny 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	/**
	 * ...
	 * @author Sarah Chan
	 */
	public class BunnyMC extends Bunny
	{
		
		var points:int = 0;
		var canJump:Boolean = true;
		var isFalling:Boolean = false;
		var groundY:int;
		var isStomping:Boolean = false;
		
		var gravity:Number = 1.2; //gravity value
		var ySpeed:int = 18; //y jumping speed of bunny
		var xSpeed:int = 0; //x speed of bunny
		var jumpTime:Number = 0; //seconds the bunny is in the air when jumping
		var dropSpd = 20;
		
		
		var canDblJump:Boolean = false; //variable that checks if the player can double jump
		var dblJumpHeight:int = 0;
		var dblJumpTime:int = 0;
		
		//masks for collision
		var maskSet:Boolean = false; //checks if the masks are set
		var feetMask:GroundMask;
		var fntMask:FrontMask;
		var groundArr:Array; //array of ground objects
		var obsArr:Array; //array of obstacle objects
		var gObsArr:Array; //array of obstacle objects
		var itemArr:Array; //Array of item objects
		
		public function BunnyMC(x:int, y:int) {
			this.x = x;
			this.y = y;
			this.addEventListener(Event.ENTER_FRAME, movement);
			this.addEventListener(Event.REMOVED_FROM_STAGE, rmvFromStg);
			groundY = y;
		}
		
		/*Set all variables to it's initial values*/
		public function resetVar():void {
			points = 0;
			canJump = true;
			isFalling = false;
			groundY = y;
			jumpTime = 0;
			isStomping = false;
		
			canDblJump = false; 
			dblJumpHeight = 0;
			dblJumpTime = 0;			
	
			this.gotoAndPlay(0);
		}
		
		/*Set the masks and object arrays for collision
		 * Parameters:
			 * @gArr -> Array of ground objects
			 * @oArr -> Array of obstacle objects
		*/
		public function setMasks(gArr:Array, oArr:Array, gOArr:Array, iArr:Array):void {
			groundArr = gArr;
			obsArr = oArr;
			gObsArr = gOArr;
			itemArr = iArr;
			
			feetMask = new GroundMask(this, groundArr, gObsArr);
			fntMask = new FrontMask(this, oArr, itemArr);
			
			
			//add the Masks in the stage
			this.root.stage.addChild(feetMask);
			this.root.stage.addChild(fntMask);
			maskSet = true;
		}
		
		/* Change the arrays for collision
		*/
		public function changeArr(gArr:Array, oArr:Array, gOArr:Array, iArr:Array):void {
			groundArr = gArr;
			obsArr = oArr;
			gObsArr = gOArr;
			itemArr = iArr;
			feetMask.changeArr(gArr, gOArr);
			fntMask.changeArr(oArr, iArr);
		}
		
		/* Checks if the Z key is pressed
		 * If it is, the bunny jump
		*/
		public function KeyDown(e:KeyboardEvent):void {
			//If z is pressed, set the bunny so it can jump
			if (e.keyCode == 90) {
				if(canJump){
					canJump = false;
					this.gotoAndStop(12); //changes the bunny sprite to "moving up"
					canDblJump = true;
					groundY = this.y;
					isFalling = false;
				}
				else if (canDblJump) {
					canDblJump = false;
					this.gotoAndStop(12);
					dblJumpHeight = this.y;
					isFalling = false;
				}
			}//if X is pressed, set the bunny so it can stomp
			else if (e.keyCode == 88) {
				isStomping = true;
				canJump = false;
				canDblJump = false;
				this.gotoAndStop(17);
			}
		}
		
		
		public function movement(e:Event): void {
			
			if (this.x >= this.parent.stage.stageWidth)
				this.x = 0;
			if (isStomping) {
				this.y += dropSpd;
				if (maskSet) {
						//if bunny has landed
						if (feetMask.checkLand()) {
							pushUp();
							groundY = this.y;
							canJump = true;
							canDblJump = false;
							isStomping = false;
							this.play(); //play bunny hopping animation again
							jumpTime = 0;
							dblJumpTime = 0;
							isFalling = false;
						}
					}else {
						if (this.y >= groundY) {
							groundY = this.y;
							canJump = true;
							canDblJump = false;
							isStomping = false;
							this.play(); //play bunny hopping animation again
							jumpTime = 0;
							dblJumpTime = 0;
							isFalling = false;
						}
					}
			}else{
				//single jumping movement
				if (!canJump && canDblJump) {
					jumpTime++;
					calcJump(groundY, jumpTime);
				}
				//double jumping movement
				else if (!canJump && !canDblJump) {
					dblJumpTime++;
					calcJump(dblJumpHeight, dblJumpTime);
				}
				//Check if the bunny is on an object or ground
				else if (canJump) {
					checkFall();
				}
			}
			
			if (fntMask.checkGetItem()) {
				points += 100;
			}

		}
		
		public function checkFall():void {
			if (!maskSet)
				return;
			
			if(!feetMask.checkLand()){
				jumpTime = (2 *ySpeed) / gravity; //set time to be the time when the final y speed is  -yspeed (vf = vi + at)
				canJump = false;
				canDblJump = true;
				isFalling = true;
				this.gotoAndPlay(12);
			}
		}
		
		/*Calculates the distance the bunny moves according the height when jumping*/
		public function calcJump(h:int, t:int):void {
			var currentYvelocity:int = -ySpeed + (gravity * t); //calculates the current y velocity
				if (currentYvelocity == 0){ //check if bunny reached the peak of its height
					isFalling = true;
					this.play(); //play landing animation
				}

				if (isFalling && currentFrame == 17) //stop the landing animation to it's landing pose
					this.stop();
				
				if (currentYvelocity == ySpeed/2) //puts a limit to the speed the bunny is falling, so it won't fall at a really high speed
					this.y += ySpeed;
				else
					this.y = h + (( -ySpeed) * t + (gravity * t * t) / 2);


				//if bunny reach certain height, it'll go down	
				if(isFalling){
					if (maskSet) {
						//if bunny has landed
						if (feetMask.checkLand()) {
							pushUp();
							groundY = this.y;
							canJump = true;
							canDblJump = false;
							isStomping = false;
							this.play(); //play bunny hopping animation again
							jumpTime = 0;
							dblJumpTime = 0;
							isFalling = false;
						}
					}else {
						if (this.y >= groundY) {
							groundY = this.y;
							canJump = true;
							canDblJump = false;
							isStomping = false;
							this.play(); //play bunny hopping animation again
							jumpTime = 0;
							dblJumpTime = 0;
							isFalling = false;
						}
					}
				}
			
		}
		
		/*pushes the bunny out of the ground when it lands*/
		public function pushUp():void {
			var pushAmount:int = feetMask.groundPushY();
			this.y = pushAmount - this.height / 2;
			
		}
		
		/* Sets what happens when the bunny lose
		 */
		public function checkLose():Boolean {
			if (feetMask.checkHit() || fntMask.checkHit()) {
				return true;
			}
			else
				return false;
		}
		
		//Returns how much points the bunny have collected
		public function getPts():int {
			return points;
		}
		
		/* Increment the points by the amount given in the parameters
		 * @param pts - points to be added
		 */
		public function addPts(pts:int):void {
			points += pts;
		}
		
		/* Remove all event listeners and masks when removed from the stage
		 */
		public function rmvFromStg(e:Event):void {
			this.removeEventListener(Event.ENTER_FRAME, movement);
			this.removeEventListener(Event.REMOVED_FROM_STAGE, rmvFromStg);
			feetMask.root.stage.addChild(feetMask);
			fntMask.root.stage.addChild(fntMask);
		}

		
	}

}