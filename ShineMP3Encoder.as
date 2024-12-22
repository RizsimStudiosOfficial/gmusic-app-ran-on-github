package
{
   import cmodule.shine.CLibInit;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.ProgressEvent;
   import flash.events.TimerEvent;
   import flash.net.FileReference;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import flash.utils.getTimer;
   
   public class ShineMP3Encoder extends EventDispatcher
   {
      public static var mp3Data:ByteArray;
      
      public var wavData:ByteArray;
      
      private var cshine:Object;
      
      private var timer:Timer;
      
      private var initTime:uint;
      
      public function ShineMP3Encoder(param1:ByteArray)
      {
         super();
         this.wavData = param1;
      }
      
      public function start() : void
      {
         this.initTime = getTimer();
         mp3Data = new ByteArray();
         this.timer = new Timer(1000 / 30);
         this.timer.addEventListener(TimerEvent.TIMER,this.update);
         this.cshine = new CLibInit().init();
         this.cshine.init(this,this.wavData,mp3Data);
         if(this.timer)
         {
            this.timer.start();
         }
      }
      
      public function shineError(param1:String) : void
      {
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.update);
         this.timer = null;
         dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,param1));
      }
      
      public function saveAs() : void
      {
         var _loc1_:FileReference = new FileReference();
         _loc1_.save(mp3Data,"filename.mp3");
      }
      
      private function update(param1:TimerEvent) : void
      {
         var _loc2_:int = int(this.cshine.update());
         dispatchEvent(new ProgressEvent(ProgressEvent.PROGRESS,false,false,_loc2_,100));
         trace("encoding mp3...",_loc2_ + "%");
         if(_loc2_ == 100)
         {
            trace("Done in",(getTimer() - this.initTime) * 0.001 + "s");
            this.timer.stop();
            this.timer.removeEventListener(TimerEvent.TIMER,this.update);
            this.timer = null;
            dispatchEvent(new Event(Event.COMPLETE));
         }
      }
   }
}

