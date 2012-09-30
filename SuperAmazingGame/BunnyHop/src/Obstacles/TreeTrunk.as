package Obstacles 
{
	/**
	 * ...
	 * @author Sarah Chan
	 */
	public class TreeTrunk extends TreeTrunkObs{
		
		public function TreeTrunk(x:int, y:int) {
			this.x = x;
			this.y = y;
		}
		
		public function createMask():TreeTrunkTop {
			return new TreeTrunkTop(x, y - 56);
		}
	}

}