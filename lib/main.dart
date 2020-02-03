import 'package:flame/components/component.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

var game;
Component component;
const SPEED = 120.0;
const ComponentSize = 40.0;

void main() async {
	WidgetsFlutterBinding.ensureInitialized();
	Flame.images.loadAll(['fire.png', 'dragon.png', 'gun.png', 'bullet.png']);
	var dimensions = await Flame.util.initialDimensions();

	game = MyGame(dimensions);
	runApp(MaterialApp(
		home: Scaffold(
			body: Container(
				decoration: new BoxDecoration(
					image: new DecorationImage(
						image: new AssetImage("assets/images/background.jpg"),
						fit: BoxFit.cover
					)
				),
				child: GameWrapper(game),
			),
		)
	));
}

class GameWrapper extends StatelessWidget {
  final MyGame game;
  GameWrapper(this.game);

	@override
  Widget build(BuildContext context) {
    return game.widget;
  }
}

class MyGame extends BaseGame {
	Size dimensions;
	double creationTimer = 0.0;
	MyGame(this.dimensions);

  @override
	void render(Canvas canvas) {
		super.render(canvas);
		String text = "Score: 0";
		TextPainter textPainter = Flame.util.text(text, color: Colors.white, fontSize: 48.0);
		textPainter.paint(canvas, Offset(size.width / 4.5, size.height - 50));
	}

	@override
	void update(double t) {
		creationTimer += t;
		if (creationTimer >= 4) {
			creationTimer = 0.0;
			component = new Component(dimensions);
      add(component);
		}
		super.update(t);
	}
}

class Component extends SpriteComponent {
  Size dimensions;
  double maxY;
  bool remove = false;
  Component(this.dimensions) : super.square(ComponentSize, 'dragon.png');

  @override
  void update(double t) {
    y += t * SPEED;
  }

	@override
  bool destroy() {
    return remove;
  }

	@override
  void resize(Size size) {
    this.x = size.width / 2;
    this.y = 0;
    this.maxY = size.height;
  }
}
