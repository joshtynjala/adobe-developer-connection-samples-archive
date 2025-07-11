package
{
	import com.adobe.utils.AGALMiniAssembler;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.textures.Texture;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	
	[SWF(width="800", height="600", frameRate="60", backgroundColor="#FFFFFF")]
	public class HelloTriangleTextured extends Sprite
	{
		[Embed( source = "RockSmooth.jpg" )]
		protected const TextureBitmap:Class;

		protected var texture:Texture;
		
		protected var context3D:Context3D;
		protected var program:Program3D;
		protected var vertexbuffer:VertexBuffer3D;
		protected var indexbuffer:IndexBuffer3D;
		
		public function HelloTriangleTextured()
		{			
			stage.stage3Ds[0].addEventListener( Event.CONTEXT3D_CREATE, initMolehill );
			stage.stage3Ds[0].requestContext3D();
			
			addEventListener(Event.ENTER_FRAME, onRender);
		}
		
		protected function initMolehill(e:Event):void
		{
			context3D = stage.stage3Ds[0].context3D;			
			context3D.configureBackBuffer(800, 600, 1, true);
			
			var vertices:Vector.<Number> = Vector.<Number>([
				-0.3,-0.3,0, 1, 0, // x, y, z, u, v
				-0.3, 0.3, 0, 0, 1,
				0.3, 0.3, 0, 1, 1]);
			
			// Create VertexBuffer3D. 3 vertices, of 5 Numbers each
			vertexbuffer = context3D.createVertexBuffer(3, 5);
			// Upload VertexBuffer3D to GPU. Offset 0, 3 vertices
			vertexbuffer.uploadFromVector(vertices, 0, 3);				
			
			var indices:Vector.<uint> = Vector.<uint>([0, 1, 2]);
			
			// Create IndexBuffer3D. Total of 3 indices. 1 triangle of 3 vertices
			indexbuffer = context3D.createIndexBuffer(3);			
			// Upload IndexBuffer3D to GPU. Offset 0, count 3
			indexbuffer.uploadFromVector (indices, 0, 3);			
			
			var bitmap:Bitmap = new TextureBitmap();
			texture = context3D.createTexture(bitmap.bitmapData.width, bitmap.bitmapData.height, Context3DTextureFormat.BGRA, false);
			texture.uploadFromBitmapData(bitmap.bitmapData);			
			
			var vertexShaderAssembler : AGALMiniAssembler = new AGALMiniAssembler();
			vertexShaderAssembler.assemble( Context3DProgramType.VERTEX,
				"m44 op, va0, vc0\n" + // pos to clipspace
				"mov v0, va1" // copy UV
			);			
			
			var fragmentShaderAssembler : AGALMiniAssembler= new AGALMiniAssembler();
			fragmentShaderAssembler.assemble( Context3DProgramType.FRAGMENT,
				"tex ft1, v0, fs0 <2d>\n" +
				"mov oc, ft1"
			);
			
			program = context3D.createProgram();
			program.upload( vertexShaderAssembler.agalcode, fragmentShaderAssembler.agalcode);
		}	
		
		protected function onRender(e:Event):void
		{
			if ( !context3D ) 
				return;
			
			context3D.clear ( 1, 1, 1, 1 );
			
			// vertex position to attribute register 0
			context3D.setVertexBufferAt (0, vertexbuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
			// UV to attribute register 1
			context3D.setVertexBufferAt(1, vertexbuffer, 3, Context3DVertexBufferFormat.FLOAT_2);
			// assign texture to texture sampler 0
			context3D.setTextureAt(0, texture);				
			// assign shader program
			context3D.setProgram(program);
			
			var m:Matrix3D = new Matrix3D();
			m.appendRotation(getTimer()/40, Vector3D.Z_AXIS);
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, m, true);
			
			context3D.drawTriangles(indexbuffer);
			
			context3D.present();			
		}
	}
}