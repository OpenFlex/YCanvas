package sk.yoz.ycanvas.demo.markers.ycanvas
{
    import flash.geom.Point;
    
    import sk.yoz.ycanvas.interfaces.IPartition;
    import sk.yoz.ycanvas.interfaces.IPartitionFactory;
    import sk.yoz.ycanvas.stage3D.interfaces.ILayerStage3D;
    import sk.yoz.ycanvas.stage3D.interfaces.IPartitionStage3D;
    
    import starling.display.DisplayObjectContainer;
    import starling.display.Sprite;
    
    public class Layer implements ILayerStage3D
    {
        public var partitionFactory:IPartitionFactory;
        
        private var _level:uint;
        private var _content:Sprite = new Sprite;
        private var _center:Point = new Point;
        private var _partitionWidth:uint;
        private var _partitionHeight:uint;
        private var _partitions:Vector.<IPartition> = new Vector.<IPartition>;
        
        public function Layer(level:uint, partitionWidth:uint, 
            partitionHeight:uint, partitionFactory:IPartitionFactory)
        {
            _level = level;
            _partitionWidth = partitionWidth;
            _partitionHeight = partitionHeight;
            this.partitionFactory = partitionFactory;
        }
        
        public function get level():uint
        {
            return _level;
        }
        
        public function get partitionWidth():uint
        {
            return _partitionWidth;
        }
        
        public function get partitionHeight():uint
        {
            return _partitionHeight;
        }
        
        public function set scale(value:Number):void
        {
            content.scaleX = content.scaleY = value;
        }
        
        public function set center(value:Point):void
        {
            _center = value;
            var length:uint = partitions.length;
            for(var i:uint = 0; i < length; i++)
                positionPartition(partitions[i]);
        }
        
        public function get center():Point
        {
            return _center;
        }
        
        public function get content():DisplayObjectContainer
        {
            return _content;
        }
        
        public function get partitions():Vector.<IPartition>
        {
            return _partitions;
        }
        
        public function addPartition(partition:IPartition):void
        {
            if(partitions.indexOf(partition) != -1)
                return;
            
            partitions.push(partition);
            positionPartition(partition);
            content.addChild((partition as IPartitionStage3D).content);
        }
        
        public function getPartition(x:int, y:int):IPartition
        {
            var length:uint = partitions.length;
            var partition:IPartition;
            for(var i:uint = 0; i < length; i++)
            {
                partition = partitions[i];
                if(partition.x == x && partition.y == y)
                    return partition;
            }
            return null;
        }
        
        public function removePartition(partition:IPartition):void
        {
            var partitionStage3D:IPartitionStage3D = partition as IPartitionStage3D;
            
            if(partitionStage3D.content)
                content.removeChild(partitionStage3D.content);
            var index:int = partitions.indexOf(partition);
            if(index != -1)
                partitions.splice(index, 1);
        }
        
        public function dispose():void
        {
            if(!partitions.length)
                return;
            
            var partition:IPartition;
            var list:Vector.<IPartition> = partitions.concat();
            for(var i:uint = 0, length:uint = list.length; i < length; i++)
            {
                partition = list[i];
                removePartition(partition);
                partitionFactory.disposePartition(partition);
            }
        }
        
        private function positionPartition(partition:IPartition):void
        {
            var partitionStage3D:IPartitionStage3D = partition as IPartitionStage3D;
            partitionStage3D.content.x = (partition.x - center.x) / level;
            partitionStage3D.content.y = (partition.y - center.y) / level;
        }
        
        public function toString():String
        {
            return "Layer: [level:" + level + "]";
        }
    }
}