mgl (Mini Game programming Library)
======================
Mgl is a mini game programming library written in Haxe + OpenFL. Mgl is useful for creating a simple Flash game in short term. HTML5/Windows build targets are partially supported.

Using the [SiON](https://github.com/keim/SiON "SiON") synthesizer library.

####Sample game

[SPACE SHIPS CONTACT ACCIDENTAL](http://abagames.sakura.ne.jp/flash/ssca/)

####Sample game (using the older version mgl)

[SIDE SHOT BOOSTER](http://abagames.sakura.ne.jp/flash/ssb/)

[MAGNETIC ACTION](http://abagames.sakura.ne.jp/flash/ma/)

[LASER WINDER](http://wonderfl.net/c/pYeI)

[LOCK ON TO ALL OF THEM](http://wonderfl.net/c/rqvL)

[DUAL PISTOLS RG](http://wonderfl.net/c/ilHX)

[TOSSED HUMANS SPLIT OVER](http://wonderfl.net/c/d8Rm)

[WASD THRUST](http://wonderfl.net/c/cUIn)

###Sample code

[BALL 28 IN SPACE](http://abagames.sakura.ne.jp/flash/b2is/)

```haxe
import mgl.*;
using mgl.F;
using mgl.U;
class Main extends G {
	function new() {
		super(this);
	}
	var beginGameSound:S;
	var endGameSound:S;
	// Start -> i() --> Title -> b() -> u()(every frame) -> Begin the game -v
	//               ^   v--------------------------------------------------<
	//               ^  b() -> u()(every frame) -> End the game -v
	//               ^-------------------------------------------<
	// First initializer.
	override function i() {
		Ball.main = this;
		// Set sounds(S) played at the game begining/ending.
		beginGameSound = S.i.mj.m().t(.5, 7, .3).t(.3, 7, .8).e;
		endGameSound = S.i.mj.m().t(.2, 7, .8).t(.8, 7, .2).e;
		// Set the title(tt) and end the initializer(ie).
		tt("BALL 28 IN SPACE").ie;
	}
	public var ballLeft:Int;
	var nextBallCount:Int;
	var time:Int;
	// Begin the title/game.
	override function b() {
		Ball.player = new Player();
		nextBallCount = 0;
		ballLeft = 28;
		time = 0;
		// Play(p) the game begining sound.
		beginGameSound.p;
	}
	// Update every frame.
	override function u() {
		var sc = Std.int(time / 1000);
		var ms = '00${time % 1000}';
		ms = ms.substr(ms.length - 3);
		// Draw elapsed time at the upper right(xy(.99, .01)) aligned right(ar).
		T.i.xy(.99, .01).ar.tx('TIME: $sc.$ms').d;
		// If the game isn't begun then return.
		if (!G.ig) return;
		time += 16;
		// Draw the number of left balls at the upper left(xy(.01, .01)).
		T.i.xy(.01, .01).tx('LEFT: $ballLeft').d;
		if (ballLeft <= 0) {
			// Play the game ending sound.
			endGameSound.p;
			// End the game.
			G.eg;
		// Get all ball actors(A.acs("Ball")) and check a total of them.
		} else if (A.acs("Ball").length <= 0) {
			nextBallCount++;
			for (i in 0...nextBallCount) new Ball();
		}
		// Instructions drawn only once(ao).
		if (G.t == 0) T.i.xy(.1, .1).tx("[urdl]: MOVE").t(180).ao;
		if (G.t == 60) T.i.xy(.1, .15).tx("[Z]: BREAK").t(180).ao;
	}
	public static function main() {
		new Main();
	}
}
// Player actor.
class Player extends A {
	static var tickSound:S;
	// Static initializer called only once.
	override function i() {
		// Set the green(c(C.gi)) shape(gs) with the dot size(sz) 3.
		d = D.i.c(C.gi).sz(3).gs(.04, .05);
		// Set the hir rect.
		hr(.04, .05);
		// Set the tick sound.
		tickSound = S.i.mn.t(.4, 3, .2).e;
	}
	// Begin this actor.
	override function b() {
		// Set the position(p) to (.5, .5).
		p.n(.5);
		// Create the fiber(F) to play the tick sound every 30 frames(w(30)).
		F.ip(this).w(30).d( { tickSound.p; } );
	}
	// Update every frame.
	override function u() {
		// Get the joystick input(K.st) and add to the velocity(v).
		v.a(K.st.m(.003)).m(K.ib ? .6 : .95);
		// Loop the position between -.05 and 1.05.
		p.xy(p.x.lr( -.05, 1.05), p.y.lr( -.05, 1.05));
		// Set the way(w) to the velocity way(v.w)
		w = v.w;
		// Add the reddish green(C.gi.gr) particle from the position p.
		P.i.p(p).c(C.gi.gr).w(w + 180, 45).s(v.l).a;
		// Check the hit to the Ball actors.
		ih("Ball");
	}
	// If the player hit the ball(b)
	override function h(b) {
		// remove the ball.
		b.remove();
	}
}
// Ball actor.
class Ball extends A {
	static public var main:Main;
	static public var player:Player;
	static var removeSound:S;
	override function i() {
		// Set the circle(cs)/yellow(C.yi) shape.
		d = D.i.c(C.yi).gc(.04);
		hr(.04);
		// Set the removing sound.
		removeSound = S.i.mn.t(.7).r().t(.7).e;
	}
	override function b() {
		for (i in 0...10) {
			// Set the random position from .1 to .9(.1.rf(.9)).
			p.xy(.1.rf(.9), .1.rf(.9));
			// If the distance to(dtd) the player is far enough then break.
			if (p.dtd(player.p) > .3) break;
		}
	}
	public function remove() {
		// Add 20(cn(20)) particles.
		P.i.p(p).c(C.yi.gr).cn(20).sz(.03).a;
		main.ballLeft--;
		// Play the removing sound.
		removeSound.p;
		// Remove this actor.
		r;
	}
}
```

###Classes

####A // Actor

##### Variables
* p:V // position
* z:Float = 0 // z position
* v:V // velocity
* w:Float = 0 // way
* s:Float = 0 // speed

##### Methods
* (static)acs(className:String):Array<Dynamic> // get actors
* (static)cl:Bool // clear actors
* (static)cls(className:String):Void // clear specific actors
* (static)sc(className:String, vx:Float, vy:Float = 0,
	minX:Float = -9999999, maxX:Float = 9999999,
	minY:Float = -9999999, maxY:Float = 9999999):Void // scroll
* t:Int // ticks
* r:Bool // remove
* hr(width:Float, height:Float = -1):A // set hit rect
* ih(className:String):Bool // is hit
* dp(priority:Int):A // set display priority

##### Overriden methods
* i():Void // initialize
* b():Void // begin
* u():Void // update
* h(hitActor:Dynamic):Void // hit

####C // Color

##### Variables
* r:Int // red
* g:Int // green
* b:Int // blue

##### Methods
* (static)ti:C // transparent instance
* (static)di:C // dark (black) instance
* (static)ri:C // red instance
* (static)gi:C // green instance
* (static)bi:C // blue instance
* (static)yi:C // yellow instance
* (static)mi:C // magenta instance
* (static)ci:C // cyan instance
* (static)wi:C // white instance
* i:Int // integer value
* v(v:C):C // set value
* gd:C // go dark
* gw:C // go white
* gr:C // go red
* gg:C // go green
* gb:C // go blue
* gbl:C // go blink
* bl(color:C, ratio:Float):C // blend

####D // DotShape

##### Methods
* (static)i:D // instance
* sz(dotSize:Int):D // set dot size
* c(color:C):D // set color
* cs(color:C):D // set color spot
* cb(color:C):D // set color bottom
* cbs(color:C):D // set color bottom spot
* si(x:Float = 0, y:Float = 0, xy:Float = 0):D // set spot interval
* st(threshold:Float):D // set spot threshold
* o(x:Float = 0, y:Float = 0):D // set offset
* fr(width:Float, height:Float, edgeWidth:Int = 0):D // fill rectangle
* lr(width:Float, height:Float, edgeWidth:Int = 1):D // line rectangle
* gr(width:Float, height:Float, seed:Int = -1):D // generate rectangle
* fc(diameter:Float, edgeWidth:Int = 0):D // fill circle
* lc(diameter:Float, edgeWidth:Int = 1):D // line circle
* gc(diameter:Float, seed:Int = -1):D // generate circle
* gs(width:Float, height:Float, seed:Int = -1):D // generate shape
* p(pos:V):D // set pos
* xy(x:Float, y:Float):D // set xy
* z(z:Float = 0):D // set z
* rt(angle:Float = 0):D // rotate
* sc(x:Float = 1, y:Float = -1):D // set scale
* ed:D // enable dot scale
* dd:D // disable dot scale
* er:D // enable rolling shape
* dc(color:C = null):D // set draw color
* d:D // draw

####F // Fiber

##### Methods
* (static)i():F // instance
* (static)ip(parent:Dynamic):F // instance with parent
* (static)cl:Bool // clear
* d(block:Expr):F // do
* w(count:Float):F // wait
* dw(count:Float):F // decrement wait
* dd:F // disable auto decrement
* dl:F // disable loop
* u:F // update
* l:F // loop
* r:F; // remove
* cn:Float; // count

####G // Game

##### Methods
* (static)ig:Bool // is in game
* (static)eg:Bool // end game
* (static)t:Int // ticks
* (static)fr(x:Float, y:Float, width:Float, height:Float, color:C):Void // fill rect
* tt(title:String, title2:String = ""):G // set title
* vr(version:Int = 1):G // set version
* dm:G // debugging mode
* yr(ratio:Float):G // set y ratio
* ie:G // initialize end

##### Overriden methods
* i():Void // initialize
* b():Void // begin
* u():Void // update
* is():Void // initialize state
* ls(d:Dynamic):Void // load state
* ss(d:Dynamic):Void // save state

####K // Key

##### Variables
* (static)s:Array<Bool> // pressed keys

##### Methods
* (static)iu:Bool // is up pressing
* (static)id:Bool // is down pressing
* (static)ir:Bool // is right pressing
* (static)il:Bool // is left pressing
* (static)ib:Bool // is button pressing
* (static)ib1:Bool // is button1 pressing
* (static)ib2:Bool // is button2 pressing
* (static)ipb:Bool // is pressed button
* (static)ipb1:Bool // is pressed button1
* (static)ipb2:Bool // is pressed button2
* (static)st:V // stick

####M // Mouse

##### Variables
* (static)p:V // pos
* (static)ip:Bool // is button pressing
* (static)ipb:Bool // is pressed button

####P // Particle

##### Methods
* (static)i:P // instance
* (static)sc(className:String, vx:Float, vy:Float = 0,
	minX:Float = -9999999, maxX:Float = 9999999,
	minY:Float = -9999999, maxY:Float = 9999999):Void // scroll
* p(pos:V):P // set position
* xy(x:Float, y:Float):P // set xy
* z(z:Float = 0):P // set z
* c(color:C):P // set color
* cn(count:Int):P // set count
* sz(size:Float):P // set size
* s(speed:Float):P // set speed
* t(ticks:Float):P // set ticks
* w(angle:Float, angleWidth:Float):P // set way
* a:P // add

####R // Random

##### Methods
* (static)i:R // instance
* n(v:Float = 1, s:Float = 0):Float // number
* ni(v:Int, s:Int = 0):Int // number int
* f(from:Float to:Float):Float // from to
* fi(from:Float to:Float):Int // from to int
* pm:Int // plus minus
* p(v:Float = 1):Float // plus minus number
* pi(v:Int):Int // plus minus number int
* s(v:Int = -0x7fffffff):R // set seed
* bst(stage:Int):R // set difficulty basis stage
* st(stage:Int, seedOffset:Int = 0):R // set stage seed
* dc:Float // difficulty corrected random

####S // SoundEffect

##### Methods
* (static)i:S // instance
* mj:S // major
* mn:S // minor
* n:S // noise
* ns:S // noise scale
* t(from:Float, time:Int = 1, to:Float = 0):S // add tone
* w(width:Float = 0, interval:Float = 0):S // set wave
* m(maxLength:Int = 3, step:Int = 1, randomSeed:Int = -1):S // set melody
* mm(min:Float = -1, max:Float = 1):S // set min max
* r(v:Int = 0):S // add rest
* rp(v:Int = 1):S // set repeat
* rr(v:Int = 0):S // set repeat rest
* l(v:Int = 64):S // set length
* v(v:Int = 16):S // set volume
* lp:S // loop
* e:S // end
* p:S // play
* fi(second:Float = 1):S // fade in
* fo(second:Float = 1):S // fade out
* s:S // stop

####T // Text

##### Methods
* (static)i:T // instance
* tx(text:String):T // set text
* p(pos:V):T // set position
* xy(x:Float, y:Float):T // set xy
* sz(dotSize:Int = -1):T // set dot size
* c(color:C):T // set color
* al:T // align left
* ar:T // align right
* ac:T // align center
* avc:T // align vertical center
* v(vel:V):T // set velocity
* vxy(x:Float, y:Float):T // set velocity xy
* t(ticks:Int):T // set ticks
* tf:T // tick forever
* ao:T // add once
* r:Bool // remove
* d:T // draw

####U // Utility

##### Methods
* (static)c(v:Float, min:Float = 0.0, max:Float = 1.0):Float // clamp
* (static)ci(v:Int, min:Int, max:Int):Int // clamp int
* (static)nw(v:Float):Float // normalize way
* (static)aw(v:Float, targetAngle:Float, angleVel:Float):Float // aim way
* (static)lr(v:Float, min:Float, max:Float):Float // loop range
* (static)lri(v:Int, min:Int, max:Int):Int // loop range int
* (static)rn(v:Float = 1, s:Float = 0):Float // random number
* (static)rni(v:Int, s:Int = 0):Int // random number int
* (static)rf(from:Float, to:Float):Float // random from to
* (static)rfi(from:Int, to:Int):Int // random from to int
* (static)rp(v:Float = 1):Float // random plus minus number
* (static)rpi(v:Int):Int // random plus minus number int
* (static)ch(o:Dynamic):Int // class hash

####V // Vector

##### Variables
* x:Float = 0 // x
* y:Float = 0 // y

##### Methods
* (static)i:V // instance
* xy(x:Float = 0, y:Float = 0):V // set xy
* n(n:Float = 0):V // set number
* v(v:V):V // set value
* l:Float // length
* w:Float // way
* xi:Int // x int
* yi:Int // y int
* dt(pos:V):Float // distance to
* dtd(pos:V, pixelWHRatio:Float = -1):Float // distance to distorted
* wt(pos:V):Float // way to
* a(v:V):V // add
* s(v:V):V // sub
* m(v:Float):V // multiply
* d(v:Float):V // divide
* aw(angle:Float, speed:Float):V // add way
* rt(angle:Float):V // rotate
* ii(spacing:Float = 0,
	minX:Float = 0, maxX:Float = 1, minY:Float = 0, maxY:Float = 1):Bool // is in

License
----------
Copyright &copy; 2013 ABA Games

Distributed under the [MIT License][MIT].

[MIT]: http://www.opensource.org/licenses/mit-license.php
