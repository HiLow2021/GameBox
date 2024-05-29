class Vector {
  static final Vector up = Vector(0, -1);
  static final Vector upRight = Vector(1, -1);
  static final Vector right = Vector(1, 0);
  static final Vector downRight = Vector(1, 1);
  static final Vector down = Vector(0, 1);
  static final Vector downLeft = Vector(-1, 1);
  static final Vector left = Vector(-1, 0);
  static final Vector upLeft = Vector(-1, -1);

  static final all = [
    Vector.up,
    Vector.upRight,
    Vector.right,
    Vector.downRight,
    Vector.down,
    Vector.downLeft,
    Vector.left,
    Vector.upLeft
  ];

  static final allWithoutDiagonal = [
    Vector.up,
    Vector.right,
    Vector.down,
    Vector.left,
  ];

  final int x;
  final int y;

  Vector(this.x, this.y);
}
