package
{
	import away3d.containers.View3D;
	import away3d.events.LoaderEvent;
	import away3d.loaders.Loader3D;
	import away3d.loaders.parsers.Parsers;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	[SWF(width="960", height="540")]
	public class GettingStartedWithAway3D extends Sprite
	{
		private var _view : View3D;
		private var _loader : Loader3D;
		
		public function GettingStartedWithAway3D()
		{
			_view = new View3D();
			_view.backgroundColor = 0x666666;
			_view.antiAlias = 4;
			
			this.addChild(_view);
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			Parsers.enableAllBundled();
			
			_loader = new Loader3D();
			_loader.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceComplete);
			_loader.addEventListener(LoaderEvent.LOAD_ERROR, onLoadError);
			_loader.load( new URLRequest('vase.awd') );
		}
		
		
		private function onResourceComplete(ev : LoaderEvent) : void
		{
			_loader.removeEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceComplete);
			_loader.removeEventListener(LoaderEvent.LOAD_ERROR, onLoadError);
			_view.scene.addChild(_loader);
		}
		
		
		private function onLoadError(ev : LoaderEvent) : void
		{
			trace('Could not find', ev.url);
			_loader.removeEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceComplete);
			_loader.removeEventListener(LoaderEvent.LOAD_ERROR, onLoadError);
			_loader = null;
		}
		
		
		private function onEnterFrame(ev : Event) : void
		{
			_loader.rotationY = stage.mouseX - stage.stageWidth/2;
			_view.camera.y = 3 * (stage.mouseY - stage.stageHeight/2);
			_view.camera.lookAt(_loader.position);
			
			_view.render();
		}
	}
}