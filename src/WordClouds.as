package
{
	import Text.TextFrequency;
	import Text.Textbitmap;
	
	import fl.controls.*;
	import fl.controls.Button;
	import fl.events.*;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.*;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.text.*;
	import flash.utils.Dictionary;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	
	public class WordClouds extends Sprite
	{
		
		private var bmpd1:BitmapData;
		private var bmp1:Bitmap;
		private var ring:Sprite;
		private var bmpdRect:BitmapData;
		private var bmpRect:Bitmap;
		
		private var c1:int = 0x4fc0a9;
		private var c2:int = 0x62aca4;
		private var c3:int = 0x518e90;
		private var color:uint;
		
		private var red:int = 0xFF0000;
		private var green:int = 0x00FF00;
		private var blue:int = 0x0000FF;
		
		private var sizeFactor:Number;
		private var sliderFactor:int = 10;
		
		private var colors:Array = new Array();
		
		private var title:TextField;
		private var titleImg:Loader;
		private var url:String = "wordcloud.png";
		private var request:URLRequest = new URLRequest(url);
		private var sizeLabel:TextField;
		
		private var newTextArea:TextArea;
		private var s:Slider;
		private var createBtn:Button;
		private var tf:TextFrequency;
		private var subSprite:Sprite;
		public function WordClouds()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			
			colors.push(c1,c2,c3);
			
			titleImg = new Loader();
			addChild(titleImg);
			with(titleImg){
				load(request);
				contentLoaderInfo.addEventListener(Event.COMPLETE,tittleComplete);
			}
//						title = new TextField();
//						addChild(title);
//						with(title){
//							text = "Word Clouds";
//							antiAliasType = AntiAliasType.ADVANCED;
//							autoSize = TextFieldAutoSize.LEFT;
//							var format:TextFormat = new TextFormat();
//							format.size = 100;
//							format.font = "Impact";
//							setTextFormat(format);
//							x = stage.stageWidth/2-width/2;
//							y = stage.stageHeight/2-height-10;
//						}
			
			newTextArea =new TextArea();
			addChild(newTextArea);
			with(newTextArea){
				width = stage.stageWidth/3.0;
				height = stage.stageHeight/8.0;
				move(stage.stageWidth/2-width/2,stage.stageHeight/2);
				editable=true;//是否允许用户编辑，默认为true
				maxChars=0;//最多可以输入多少个字符，0为不限制
				text="Input the text to create the word cloud";//默认显示什么内容
			}
			
			s = new Slider();
			addChild(s);
			with(s){
				width = stage.stageWidth/4.0;
				height = stage.stageHeight/10.0;
				move(stage.stageWidth/2-width/2,stage.stageHeight/2+stage.stageHeight/8+10);
				liveDragging = true;
				minimum = 1;
				maximum = 20;
				s.value = 10;
				addEventListener(SliderEvent.CHANGE, announceChange);
			}
			
			sizeLabel = new TextField();
			addChild(sizeLabel);
			with(sizeLabel){
				text = "Drag to Change the Clouds Size: 10";
				autoSize = TextFieldAutoSize.LEFT;
				x = stage.stageWidth/2-width/2;
				y = stage.stageHeight/2+stage.stageHeight/8+30;
				var format:TextFormat = new TextFormat();
				format.font = "Arial";
				setTextFormat(format);
			}
			
			createBtn = new Button();
			addChild(createBtn);
			with(createBtn){
				label="Create WordCloud!";
				width=stage.stageWidth/5.0;
				width=stage.stageHeight/4.0;
				move(stage.stageWidth/2-width/2,stage.stageHeight/2+stage.stageHeight/8+60);
				addEventListener(MouseEvent.CLICK,createWord);
			}
			
			
			//			var colors4 : Array = [0xFF0000,0x00FF00,0x0000FF];
			//			var alphas : Array = [1,1,1];
			//			var ratios : Array = [0,175,255];
			//			var matrix : Matrix = new Matrix();
			////			matrix.createGradientBox(stage.stageWidth/7.0, stage.stageHeight/36.0, 0, 40, 0);
			//			matrix.createGradientBox(500, 200, 0, 0, 0);
			//			rect = new Sprite();
			//			rect.graphics.beginGradientFill(GradientType.LINEAR, colors4, alphas, ratios, matrix);
			//			rect.graphics.drawRect(stage.stageWidth/32,stage.stageHeight/32+stage.stageHeight/3.0+20,stage.stageWidth/7.0, stage.stageHeight/36.0);
			////			bmpdRect = snapClip(rect);
			//			bmpRect = new Bitmap(bmpdRect);
			//			var bmpdata:BitmapData = new BitmapData(500,500);
			//			bmpdata.draw(rect);
			//			bmpRect.bitmapData = bmpdata;
			//			
			//			trace(bmpRect.x+","+bmpRect.y);
			//			trace(rect.x+","+rect.y);
			//			bmpRect.x = stage.stageWidth/32;
			//			bmpRect.y = stage.stageHeight/32+stage.stageHeight/3.0+20;
			//			addChild(bmpRect);
			//			var txt:TextField = new TextField();
			//			txt.text = "Dic: ";
			//			txt.setTextFormat(new TextFormat("Arial",20));
			//			txt.x = 50;
			//			txt.y = 50;
			//			txt.autoSize = TextFieldAutoSize.LEFT;
			//			addChild(txt);
			
			//			tf = new TextFrequency("Google was founded by Larry Page and Sergey Brin while" +
			//				" they were Ph.D. students at Stanford University. Together they own about 16 percent of its shar" +
			//				"es. They incorporated Google as a privately held company on September 4, 1998. An initial publi" +
			//				"c offering followed on August 19, 2004. Its mission statement from the outset was \"to organize the " +
			//				"world's information and make it universally accessible and useful\",[10] and its unofficial slogan was \"Don't b" +
			//				"e evil\".[11][12] In 2006 Google moved to headquarters in Mountain View, California, nickname" +
			//				"d the Googleplex. Google on ad-tech London, 2010 Rapid growth since incorporation has triggere" +
			//				"d a chain of products, acquisitions and partnerships beyond Google's core search engine. It offers on" +
			//				"line productivity software including email (Gmail), an office suite (Google Drive), and social networki" +
			//				"ng (Google+). Desktop products include applications for web browsing, organizing and editing photo" +
			//				"s, and instant messaging. The company leads the development of the Android mobile operating syste" +
			//				"m and the browser-only Chrome OS[13] for a netbook known as a Chromebook.");
			
			/*
			var wordsArray:Array = new Array();
			var len:int = tf.wary.length;
			for(var i:int = 0;i<len;i++){
			var size:int;
			size= (tf.fary[i])*20;
			
			var g:int = randRange(0,100);
			var r:int = randRange(0,100);
			var b:int = randRange(0,100);
			
			var color:int = 0xff*16*16*16*16*r/100.0+0xff*16*16*g/100.0+0xff*b/100.0;
			
			var word:Textbitmap = new Textbitmap(tf.wary[i], size, color,  stage.stageWidth/2, stage.stageHeight/2);
			var bmp:Bitmap =  word.bmp;
			var bmpd:BitmapData =  word.bmpd;
			
			var x:Sprite = new Sprite();
			x.addChild(bmp);
			
			addChild(x);
			
			while(hitBetweenAll(word,wordsArray) ){
			bmp.x +=  randRange(-10, 10);
			bmp.y += randRange(-10, 10);
			}
			wordsArray.push(word);
			}*/
			
			//			for(var i:int = 0;i<20;i++){
			//				var size:int = randRange(4,18)*5;
			//				var color:int = randRange(0,2);
			//				var word:Textbitmap = new Textbitmap("Darkmap", size, colors[color],  stage.stageWidth/2, stage.stageHeight/2);
			//				var bmp:Bitmap =  word.bmp;
			//				var bmpd:BitmapData =  word.bmpd;
			//				
			//				var x:Sprite = new Sprite();
			//				x.addChild(bmp);
			//				
			//				addChild(x);
			//				
			//				var len:int = wordsArray.length;
			//					while(hitBetweenAll(word,wordsArray) ){
			//						bmp.x +=  randRange(-3, 3);
			//						bmp.y += randRange(-3, 3);
			//					}
			//				wordsArray.push(word);
			//				
			//			}
			
			//			addEventListener(MouseEvent.MOUSE_DOWN, onMouseClick);
		}
		
		//		private function onMouseClick(event:MouseEvent):void {
		//			color = bmpdRect.getPixel(event.localX, event.localY);
		//			var colorStr:String=("0x"+color.toString(16)+"00000").slice(0,8);
		//			trace(colorStr);
		//			trace(event.localX+","+event.localY);
		//			
		//		}
		
		/*private function onMouseMoving(event:MouseEvent):void {
		// 将 bmp2 移动到鼠标的位置（中心）
		bmp2.x = mouseX-100;
		bmp2.y = mouseY-100;
		}*/
		
		private function tittleComplete (event:Event):void
		{
			var loaderInfo:LoaderInfo = event.target as LoaderInfo;
			titleImg.x = stage.stageWidth/2-loaderInfo.width/2;
			titleImg.y = stage.stageHeight/2-loaderInfo.height-40;
		}
		
		function announceChange(e:SliderEvent):void {
			sliderFactor = e.target.value;
			sizeLabel.text = "Drag to Change the Clouds Size: " + sliderFactor;
			var format:TextFormat = new TextFormat();
			format.font = "Arial";
			sizeLabel.setTextFormat(format);
			trace("Drag to Change the Clouds Size: " + sliderFactor);
		}
		
		function switchSliderDirection(e:Event):void {
			if(s.direction == SliderDirection.HORIZONTAL) {
				s.direction = SliderDirection.VERTICAL;
			}
			else {
				s.direction = SliderDirection.HORIZONTAL;
			}
		}
		
		function createWord(eve:Event)
		{
			tf = new TextFrequency(newTextArea.text);
			removeChild(newTextArea);
			removeChild(createBtn);
			removeChild(s);
			removeChild(sizeLabel);
			removeChild(titleImg);
			createWordCloud(tf);
		}
		
		function createWordCloud(txt:TextFrequency){
			var wordsArray:Array = new Array();
			var len:int = txt.wary.length;
			
			
			var maxSize:int = 0;
			for each(var maxCount:int in txt.fary){
				if(maxCount>maxSize)
					maxSize = maxCount;
			}
			trace("maxSize:"+maxSize);	
			
			sizeFactor = 10/maxSize;
			
			//			trace("maxSize: "+maxSize);
			//			sizeFactor = 200.0/maxSize;
			
			for(var i:int = 0;i<len;i++){
				var size:int;
				size= (txt.fary[i])*sliderFactor*sizeFactor;
				
				var g:int = randRange(0,100);
				var r:int = randRange(0,100);
				var b:int = randRange(0,100);
				
				var color:int = 0xff*16*16*16*16*r/100.0+0xff*16*16*g/100.0+0xff*b/100.0;
				
				var word:Textbitmap = new Textbitmap(txt.wary[i], size, color,  stage.stageWidth/2, stage.stageHeight/2);
				var bmp:Bitmap =  word.bmp;
				var bmpd:BitmapData =  word.bmpd;
				
				var x:Sprite = new Sprite();
				x.addChild(bmp);
				
				addChild(x);
				
				while(hitBetweenAll(word,wordsArray) ){
					bmp.x +=  randRange(-10, 10);
					bmp.y += randRange(-10, 10);
				}
				wordsArray.push(word);
			}
		}
		
		function snapClip( clip:DisplayObject ):BitmapData
		{
			var bounds:Rectangle = clip.getBounds( clip );
			var bitmap:BitmapData = new BitmapData( int( bounds.width + 0.5 ), int( bounds.height + 0.5 ), true, 0 );
			bitmap.draw( clip, new Matrix(1,0,0,1,-bounds.x,-bounds.y) );
			return bitmap;
		}
		
		function hitBetweenAll(w1:Textbitmap, wA:Array):Boolean {
			var len:int = wA.length;
			for(var j:int = 0;j<len; j++){
				var w2:Textbitmap = wA[j];
				if(hitBetweenTwo(w1,w2))
					return true;
			}
			return false;
		}
		
//		function rotate():void{
//			ring = new Sprite();
//			ring.x = stage.stageWidth/2;
//			ring.y = stage.stageHeight/2;
//			var radius:Number =50;
//			for(var idx:int=0; idx<12; idx++){
//				ring.graphics.beginFill(0x508baf,1);
//				ring.graphics.drawCircle(radius*Math.cos(2*Math.PI/12*idx),radius*Math.sin(2*Math.PI/12*idx),5);
//			}
//			addChild(ring);
////			var colors4 : Array = [0xFF0000,0x00FF00,0x0000FF];
////			var alphas : Array = [1,1,1];
////			var ratios : Array = [0,175,255];
////			var matrix : Matrix = new Matrix();
////			matrix.createGradientBox(stage.stageWidth/7.0, stage.stageHeight/36.0, 0, 40, 0);
////			matrix.createGradientBox(400, 400, 0, 0, 0);
////			ring = new Sprite();
////			ring.graphics.beginGradientFill(GradientType.RADIAL, colors4, alphas, ratios, matrix);
////			ring.graphics.drawCircle(stage.stageWidth/2, stage.stageHeight/2, 50);
//		}
//		
//		function rotateHandler(e:Event):void{
//			
//		}
		
		function hitBetweenTwo(w1:Textbitmap, w2:Textbitmap):Boolean {
			var bmpa:Bitmap =  w1.bmp;
			var bmpda:BitmapData =  w1.bmpd;
			var bmpb:Bitmap =  w2.bmp;
			var bmpdb:BitmapData =  w2.bmpd;
			return bmpda.hitTest(new Point(bmpa.x, bmpa.y), 255, bmpdb, new Point(bmpb.x, bmpb.y), 255)
		}
		
		function randRange(min:Number, max:Number):Number {
			var randomNum:Number = Math.floor(Math.random() * (max - min + 1)) + min;
			return randomNum;
		}
	}
}