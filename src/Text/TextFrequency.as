package Text
{
	import flash.utils.Dictionary;
	
	public class TextFrequency
	{
		public var sary:Array;
		public var wary:Array;
		public var fary:Array;
		private var count:int;
		public function TextFrequency(txt:String)
		{
			wary = new Array();
			fary = new Array();
			
			var pattern:RegExp = /\r| /; 
			sary = txt.split(pattern);
			var len:int = sary.length;
			for(var i:int = 0;i<len;i++){
				var str:String = sary[i];
				if(str.toLocaleLowerCase()=="the"||
					str.toLocaleLowerCase()=="a"||
					str.toLocaleLowerCase()=="be"||
					str.toLocaleLowerCase()=="at"||
					str.toLocaleLowerCase()=="all"||
					str.toLocaleLowerCase()=="has"||
					str.toLocaleLowerCase()=="have"||
					str.toLocaleLowerCase()=="with"||
					str.toLocaleLowerCase()=="on"||
					str.toLocaleLowerCase()=="it"||
					str.toLocaleLowerCase()=="for"||
					str.toLocaleLowerCase()=="that"||
					str.toLocaleLowerCase()=="and"||
					str.toLocaleLowerCase()=="an"||
					str.toLocaleLowerCase()=="is"||
					str.toLocaleLowerCase()=="in"||
					str.toLocaleLowerCase()=="to"||
					str.toLocaleLowerCase()=="of"||
					str.toLocaleLowerCase()=="are"||
					str.toLocaleLowerCase()=="from"||
					str.toLocaleLowerCase()=="am")
					continue;
				var has:Boolean = false;
				var index:int = -1;
				for each(var tstr:String in wary){
					index++;
					if(tstr.toLowerCase()==str.toLowerCase()){
						trace();
						has = true;
						break;
					}
				}
				if(!has){
					fary.push(1);
					wary.push(str);
				}
				else
					fary[index]+=1;
				count++;
			}
			
			//			var flen:int = fary.length;
			//			for (var j:int =0;j<flen; j++){
			//				fary[j] = fary[j]*1.0 / count;
			//			}
			
			trace(wary.toString());
			trace(fary.toString());
			
		}
		
		
		
	}
}