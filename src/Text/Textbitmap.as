package Text
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.text.*;
	import flash.geom.Matrix;
	
	public class Textbitmap extends Bitmap
	{
		public var bmpd:BitmapData;
		public var bmp:Bitmap;
		
		public function Textbitmap(text:String, size:int, color:int, x:int, y:int)
		{
			var txt:TextField = new TextField();
			txt.text = text;
			txt.antiAliasType = AntiAliasType.ADVANCED;
			var format:TextFormat = new TextFormat();
			format.font = "Impact";
			format.color = color;
			format.size = size;
			txt.setTextFormat(format);
			txt.autoSize=TextFieldAutoSize.LEFT;
			
			// 创建一个合适的位图
			bmpd = new BitmapData(txt.width, txt.height, true, 0);
			bmpd.draw(txt, new Matrix(1, 0, 0, 1, 0, 0));
			bmp = new Bitmap(bmpd);
			
			if(randRange(0,1)==0){
				var matrix:Matrix = new Matrix();
				matrix.translate(-bmp.width / 2, -bmp.height / 2);
				matrix.rotate(90 * (Math.PI / 180));
				matrix.translate(bmp.height /2, bmp.width/2);
				bmpd = new BitmapData(txt.height, txt.width, true, 0x00000000);
				bmpd.draw(bmp, matrix);
				bmp = new Bitmap(bmpd);
			}
			
			bmp.x = x-txt.width/2.0;
			bmp.y = y-txt.height/2.0;
		}
		
		function randRange(min:Number, max:Number):Number {
			var randomNum:Number = Math.floor(Math.random() * (max - min + 1)) + min;
			return randomNum;
		}
	}
}