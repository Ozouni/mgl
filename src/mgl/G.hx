package mgl;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.filters.BlurFilter;
import flash.filters.ColorMatrixFilter;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.Lib;
class G { // Game
	public function new(current:MovieClip, main:Dynamic) { initialize(current, main); }
	public var a:A;
	public var c:C;
	public var d:D;
	public var k:K;
	public var l:L;
	public var m:M;
	public var p:P;
	public var r:R;
	public var s:S;
	public var t:T;
	public var u:U;
	public var v:V;
	public function tt(title:String):G { return setTitle(title); }
	public var dm(setDebuggingMode, null):G;
	public function pl(platform:Dynamic):G { return setPlatform(platform); }
	public function bc(backgroundColor:C):G { return setBackgroundColor(backgroundColor); }
	public var b(begin, null):G;
	public var ig(getIsInGame, null):Bool;
	public var tc(getTicks, null):Int;
	public function ua(actors:Array<Dynamic>):G { return updateActors(actors); }
	public var dp(drawParticles, null):G;
	public function fr(x:Float, y:Float, width:Float, height:Float, color:C):G {
		return fillRect(x, y, width, height, color);
	}
	public function sc(score:Int):G { return addScore(score); }
	public var eg(endGame, null):Bool;
	
	public var bd:BitmapData;
	var current:MovieClip;
	var main:Dynamic;
	var title = "";
	var isDebugging = false;
	var platform:Dynamic;
	var score = 0;
	var isInGame = false;
	var ticks = 0;
	var fps = 0.0;
	var isPaused = false;
	var wasClicked = false;
	var wasReleased = false;
	var titleTicks = 0;
	var screenWidth:Int;
	var screenHeight:Int;
	var blurBd:BitmapData;
	var baseSprite:Sprite;
	var fRect:Rectangle;
	var fadeFilter:ColorMatrixFilter;
	var blurFilter10:BlurFilter;
	var blurFilter20:BlurFilter;
	var zeroPoint:Point;
	var backgroundColor:C;
	var fpsCount = 0;
	var lastTimer = 0;
	function initialize(current:MovieClip, main:Dynamic):Void {
		Lib.current = current;
		this.main = main;
		platform = new Platform();
		initializeScreen();
		C.initialize();
		D.initialize(this);
		L.initialize(this);
		P.initialize(this);
		S.initialize(this);
		T.initialize();
		a = new A();
		c = new C();
		d = new D();
		k = new K();
		l = new L();
		m = new M(baseSprite);
		p = new P();
		r = new R();
		t = new T();
		s = new S();
		u = new U();
		v = new V();
		setBackgroundColor(c.di);
	}
	function setTitle(title:String):G {
		this.title = title;
		return this;
	}
	function setDebuggingMode():G {
		isDebugging = true;
		return this;
	}
	function setPlatform(platform:Dynamic):G {
		this.platform = platform;
		return this;
	}
	function setBackgroundColor(backgroundColor:C):G {
		baseSprite.graphics.beginFill(backgroundColor.i);
		baseSprite.graphics.drawRect(0, 0, screenWidth, screenHeight);
		baseSprite.graphics.endFill();
		return this;
	}
	function begin():G {
		initializeGame();
		if (isDebugging) beginGame();
		else platform.showHighScore();
		lastTimer = Lib.getTimer();
		Lib.current.addEventListener(Event.ACTIVATE, onActivated);
		Lib.current.addEventListener(Event.DEACTIVATE, onDeactivated);
		Lib.current.addEventListener(Event.ENTER_FRAME, updateFrame);
		return this;
	}
	function getIsInGame():Bool {
		return isInGame;
	}
	function getTicks():Int {
		return ticks;
	}
	function updateActors(actors:Array<Dynamic>):G {
		var i = 0;
		while (i < actors.length) {
			if (actors[i].update()) i++;
			else actors.splice(i, 1);
		}
		return this;
	}
	function drawParticles():G {
		updateActors(P.ps);
		return this;
	}
	function fillRect(x:Float, y:Float, width:Float, height:Float, color:C):G {
		var w = width * screenWidth;
		var h = height * screenHeight;
		fRect.x = Std.int(x * screenWidth) - Std.int(w / 2);
		fRect.y = Std.int(y * screenHeight) - Std.int(h / 2);
		fRect.width = w;
		fRect.height = h;
		bd.fillRect(fRect, color.i);
		return this;
	}
	function addScore(score:Int):G {
		this.score += score;
		return this;
	}
	function endGame():Bool {
		if (!isInGame) return false;
		platform.recordHighScore(score);
		platform.showHighScore();
		isInGame = false;
		wasClicked = wasReleased = false;
		ticks = 0;
		titleTicks = 10;
		return true;
	}
	
	function initializeScreen() {
		Lib.current.stage.align = StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		fadeFilter = new ColorMatrixFilter(
			[1, 0, 0, 0, 0,  0, 1, 0, 0, 0,  0, 0, 1, 0, 0,  0, 0, 0, 0.8, 0]);
		blurFilter10 = new BlurFilter(10, 10);
		blurFilter20 = new BlurFilter(20, 20);
		zeroPoint = new Point();
		screenWidth = Lib.current.stage.stageWidth;
		screenHeight = Lib.current.stage.stageHeight;
		bd = new BitmapData(screenWidth, screenHeight, true, 0);
		blurBd = new BitmapData(screenWidth, screenHeight, true, 0);
		var blurBitmap = new Bitmap(blurBd);
		baseSprite = new Sprite();
		baseSprite.addChild(blurBitmap);
		Lib.current.addChild(baseSprite);
		fRect = new Rectangle();
	}
	function beginGame():Void {
		isInGame = true;
		score = 0;
		ticks = 0;
		platform.closeHighScore();
		r.s();
		initializeGame();
	}
	function initializeGame():Void {
		P.initialize(this);
		T.initialize();
		main.b();
	}
	function updateFrame(e:Event):Void {
		beginScreen();
		if (!isPaused) {
			main.u();
			updateActors(T.s);
			if (isDebugging) {
				l.ar.t("FPS: " + Std.string(Std.int(fps))).xy(1, 0.03).d.ac;
			}
			S.updateAll();
			ticks++;
		} else {
			l.t("PAUSED").xy(0.5, 0.45).d;
			l.t(platform.clickStr + " TO RESUME").xy(0.5, 0.55).d;
		}
		l.ar.t(Std.string(score)).xy(1, 0).d.ac;
		if (!isInGame) handleTitleScreen();
		endScreen();
		calcFps();
	}
	function beginScreen():Void {
		bd.lock();
		bd.fillRect(bd.rect, 0);
	}
	function endScreen():Void {
		bd.unlock();
		drawBlur();
	}
	function drawBlur():Void {
		blurBd.lock();
		blurBd.applyFilter(blurBd, blurBd.rect, zeroPoint, fadeFilter);
		blurBd.copyPixels(bd, bd.rect, zeroPoint, null, null, true);
		blurBd.applyFilter(blurBd, blurBd.rect, zeroPoint, blurFilter20);
		blurBd.copyPixels(bd, bd.rect, zeroPoint, null, null, true);
		blurBd.applyFilter(blurBd, blurBd.rect, zeroPoint, blurFilter10);
		blurBd.copyPixels(bd, bd.rect, zeroPoint, null, null, true);
		blurBd.unlock();
	}
	function handleTitleScreen():Void {
		var tx = platform.titleX;
		l.t(title).xy(tx, 0.4).d;
		l.t(platform.clickStr).xy(tx, 0.54).d;
		l.t("TO").xy(tx, 0.57).d;
		l.t("START").xy(tx, 0.6).d;
		if (m.ip) {
			if (wasReleased) wasClicked = true;
		} else {
			if (wasClicked) beginGame();
			if (--titleTicks <= 0) wasReleased = true;
		}
	}
	function onActivated(e:Event):Void {
		isPaused = false;
	}
	function onDeactivated(e:Event):Void {
		k.r;
		if (isInGame) isPaused = true;
	}
	function calcFps():Void {
		fpsCount++;
		var currentTimer:Int = Lib.getTimer();
		var delta:Int = currentTimer - lastTimer;
		if (delta >= 1000) {
			fps = fpsCount * 1000 / delta;
			lastTimer = currentTimer;
			fpsCount = 0;
		}
	}
}
class Platform {
	public var clickStr = "CLICK";
	public var isTouchDevice = false;
	public var titleX = 0.5;
	public function new() { }
	public function recordHighScore(score:Int):Void { }
	public function showHighScore():Void { }
	public function closeHighScore():Void { }
}