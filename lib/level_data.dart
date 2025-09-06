class BlockData {
  final int row;
  final int col;
  final int health;

  BlockData({required this.row, required this.col, this.health = 1});
}

class LevelData {
  final List<BlockData> blocks;
  final double ballSpeed;

  LevelData({required this.blocks, required this.ballSpeed});
}

final List<LevelData> gameLevels = [
  // Level 1: Simple rectangle
  LevelData(
    ballSpeed: 280,
    blocks: [
      for (int r = 0; r < 4; r++)
        for (int c = 1; c < 7; c++) BlockData(row: r, col: c, health: 1),
    ],
  ),
  
  // Level 2: Pyramid
  LevelData(
    ballSpeed: 320,
    blocks: [
      for (int r = 0; r < 5; r++)
        for (int c = r; c < 8 - r; c++)
          BlockData(row: r, col: c, health: (r % 2) + 1),
    ],
  ),
  
  // Level 3: Checkerboard
  LevelData(
    ballSpeed: 360,
    blocks: [
      for (int r = 0; r < 5; r++)
        for (int c = 0; c < 8; c++)
          if ((r + c) % 2 == 0) BlockData(row: r, col: c, health: 2),
    ],
  ),
  
  // Level 4: Strong top rows
  LevelData(
    ballSpeed: 400,
    blocks: [
      for (int r = 0; r < 5; r++)
        for (int c = 0; c < 8; c++)
          BlockData(row: r, col: c, health: (5 - r) ~/ 2 + 1),
    ],
  ),
  
  // Level 5: Diamond pattern
  LevelData(
    ballSpeed: 420,
    blocks: [
      // Top diamond
      BlockData(row: 0, col: 3, health: 3),
      BlockData(row: 0, col: 4, health: 3),
      BlockData(row: 1, col: 2, health: 2),
      BlockData(row: 1, col: 3, health: 3),
      BlockData(row: 1, col: 4, health: 3),
      BlockData(row: 1, col: 5, health: 2),
      BlockData(row: 2, col: 1, health: 1),
      BlockData(row: 2, col: 2, health: 2),
      BlockData(row: 2, col: 3, health: 3),
      BlockData(row: 2, col: 4, health: 3),
      BlockData(row: 2, col: 5, health: 2),
      BlockData(row: 2, col: 6, health: 1),
      BlockData(row: 3, col: 2, health: 2),
      BlockData(row: 3, col: 3, health: 3),
      BlockData(row: 3, col: 4, health: 3),
      BlockData(row: 3, col: 5, health: 2),
      BlockData(row: 4, col: 3, health: 3),
      BlockData(row: 4, col: 4, health: 3),
    ],
  ),
  
  // Level 6: Corridor challenge
  LevelData(
    ballSpeed: 440,
    blocks: [
      // Left wall
      for (int r = 0; r < 5; r++) BlockData(row: r, col: 0, health: 2),
      for (int r = 0; r < 5; r++) BlockData(row: r, col: 1, health: 1),
      // Right wall  
      for (int r = 0; r < 5; r++) BlockData(row: r, col: 6, health: 1),
      for (int r = 0; r < 5; r++) BlockData(row: r, col: 7, health: 2),
      // Center obstacles
      BlockData(row: 1, col: 3, health: 3),
      BlockData(row: 1, col: 4, health: 3),
      BlockData(row: 3, col: 2, health: 2),
      BlockData(row: 3, col: 5, health: 2),
    ],
  ),
  
  // Level 7: X marks the spot
  LevelData(
    ballSpeed: 460,
    blocks: [
      // X pattern
      for (int i = 0; i < 5; i++) ...[
        BlockData(row: i, col: i, health: 2 + i ~/ 2),
        BlockData(row: i, col: 7 - i, health: 2 + i ~/ 2),
      ],
      // Center reinforcement
      BlockData(row: 2, col: 3, health: 3),
      BlockData(row: 2, col: 4, health: 3),
    ],
  ),
  
  // Level 8: Fortress walls
  LevelData(
    ballSpeed: 480,
    blocks: [
      // Top wall
      for (int c = 0; c < 8; c++) BlockData(row: 0, col: c, health: 3),
      // Side walls
      for (int r = 1; r < 4; r++) ...[
        BlockData(row: r, col: 0, health: 3),
        BlockData(row: r, col: 7, health: 3),
      ],
      // Inner defenses
      BlockData(row: 1, col: 2, health: 2),
      BlockData(row: 1, col: 5, health: 2),
      BlockData(row: 2, col: 1, health: 2),
      BlockData(row: 2, col: 6, health: 2),
      BlockData(row: 2, col: 3, health: 1),
      BlockData(row: 2, col: 4, health: 1),
      BlockData(row: 3, col: 2, health: 1),
      BlockData(row: 3, col: 5, health: 1),
    ],
  ),
  
  // Level 9: Spiral pattern
  LevelData(
    ballSpeed: 500,
    blocks: [
      // Outer spiral
      ...List.generate(8, (i) => BlockData(row: 0, col: i, health: 1)),
      ...List.generate(4, (i) => BlockData(row: i + 1, col: 7, health: 1)),
      ...List.generate(7, (i) => BlockData(row: 4, col: 6 - i, health: 1)),
      ...List.generate(3, (i) => BlockData(row: 3 - i, col: 0, health: 1)),
      ...List.generate(5, (i) => BlockData(row: 1, col: i + 1, health: 2)),
      ...List.generate(2, (i) => BlockData(row: i + 2, col: 5, health: 2)),
      ...List.generate(3, (i) => BlockData(row: 3, col: 4 - i, health: 2)),
      BlockData(row: 2, col: 2, health: 3),
      BlockData(row: 2, col: 3, health: 3),
    ],
  ),
  
  // Level 10: Double pyramid
  LevelData(
    ballSpeed: 520,
    blocks: [
      // Top pyramid
      BlockData(row: 0, col: 1, health: 1),
      BlockData(row: 0, col: 6, health: 1),
      BlockData(row: 1, col: 0, health: 2),
      BlockData(row: 1, col: 1, health: 2),
      BlockData(row: 1, col: 6, health: 2),
      BlockData(row: 1, col: 7, health: 2),
      BlockData(row: 2, col: 0, health: 3),
      BlockData(row: 2, col: 1, health: 3),
      BlockData(row: 2, col: 2, health: 1),
      BlockData(row: 2, col: 5, health: 1),
      BlockData(row: 2, col: 6, health: 3),
      BlockData(row: 2, col: 7, health: 3),
      // Center gap
      BlockData(row: 3, col: 1, health: 2),
      BlockData(row: 3, col: 6, health: 2),
      // Bottom inverted pyramid
      BlockData(row: 4, col: 2, health: 1),
      BlockData(row: 4, col: 3, health: 2),
      BlockData(row: 4, col: 4, health: 2),
      BlockData(row: 4, col: 5, health: 1),
    ],
  ),
  
  // Level 11: Maze runner
  LevelData(
    ballSpeed: 540,
    blocks: [
      // Maze walls
      for (int r = 0; r < 5; r++) ...[
        if (r != 2) BlockData(row: r, col: 2, health: 3),
        if (r != 1 && r != 3) BlockData(row: r, col: 4, health: 3),
        if (r != 2) BlockData(row: r, col: 6, health: 3),
      ],
      // Side barriers
      BlockData(row: 1, col: 0, health: 2),
      BlockData(row: 3, col: 0, health: 2),
      BlockData(row: 1, col: 7, health: 2),
      BlockData(row: 3, col: 7, health: 2),
      // Strategic blocks
      BlockData(row: 0, col: 1, health: 1),
      BlockData(row: 0, col: 5, health: 1),
      BlockData(row: 4, col: 1, health: 1),
      BlockData(row: 4, col: 5, health: 1),
    ],
  ),
  
  // Level 12: Ring of fire
  LevelData(
    ballSpeed: 560,
    blocks: [
      // Outer ring
      for (int c = 1; c < 7; c++) BlockData(row: 0, col: c, health: 3),
      for (int c = 1; c < 7; c++) BlockData(row: 4, col: c, health: 3),
      for (int r = 1; r < 4; r++) ...[
        BlockData(row: r, col: 0, health: 3),
        BlockData(row: r, col: 7, health: 3),
      ],
      // Inner ring
      BlockData(row: 1, col: 2, health: 2),
      BlockData(row: 1, col: 5, health: 2),
      BlockData(row: 2, col: 1, health: 2),
      BlockData(row: 2, col: 6, health: 2),
      BlockData(row: 3, col: 2, health: 2),
      BlockData(row: 3, col: 5, health: 2),
      // Core
      BlockData(row: 2, col: 3, health: 1),
      BlockData(row: 2, col: 4, health: 1),
    ],
  ),
  
  // Level 13: Lightning bolt
  LevelData(
    ballSpeed: 580,
    blocks: [
      // Lightning pattern
      BlockData(row: 0, col: 2, health: 3),
      BlockData(row: 0, col: 3, health: 3),
      BlockData(row: 1, col: 1, health: 2),
      BlockData(row: 1, col: 2, health: 3),
      BlockData(row: 1, col: 4, health: 2),
      BlockData(row: 1, col: 5, health: 2),
      BlockData(row: 2, col: 0, health: 1),
      BlockData(row: 2, col: 3, health: 3),
      BlockData(row: 2, col: 4, health: 3),
      BlockData(row: 2, col: 6, health: 1),
      BlockData(row: 3, col: 2, health: 2),
      BlockData(row: 3, col: 5, health: 2),
      BlockData(row: 3, col: 6, health: 2),
      BlockData(row: 4, col: 4, health: 1),
      BlockData(row: 4, col: 5, health: 1),
      // Side support
      BlockData(row: 1, col: 0, health: 1),
      BlockData(row: 1, col: 7, health: 1),
      BlockData(row: 3, col: 1, health: 1),
      BlockData(row: 3, col: 7, health: 1),
    ],
  ),
  
  // Level 14: Castle defense
  LevelData(
    ballSpeed: 600,
    blocks: [
      // Castle walls (full perimeter)
      for (int c = 0; c < 8; c++) BlockData(row: 0, col: c, health: 3),
      for (int r = 1; r < 5; r++) ...[
        BlockData(row: r, col: 0, health: 3),
        BlockData(row: r, col: 7, health: 3),
      ],
      // Inner keep
      BlockData(row: 2, col: 2, health: 3),
      BlockData(row: 2, col: 3, health: 3),
      BlockData(row: 2, col: 4, health: 3),
      BlockData(row: 2, col: 5, health: 3),
      // Guard towers
      BlockData(row: 1, col: 1, health: 2),
      BlockData(row: 1, col: 6, health: 2),
      BlockData(row: 3, col: 1, health: 2),
      BlockData(row: 3, col: 6, health: 2),
      // Weak points
      BlockData(row: 1, col: 3, health: 1),
      BlockData(row: 1, col: 4, health: 1),
      BlockData(row: 3, col: 3, health: 1),
      BlockData(row: 3, col: 4, health: 1),
    ],
  ),
  
  // Level 15: Final boss - Impossible fortress
  LevelData(
    ballSpeed: 650,
    blocks: [
      // Massive fortress with maximum difficulty
      for (int r = 0; r < 5; r++)
        for (int c = 0; c < 8; c++) ...[
          if (r == 0 || r == 4 || c == 0 || c == 7) // Perimeter
            BlockData(row: r, col: c, health: 3)
          else if ((r == 1 && (c == 2 || c == 5)) || (r == 3 && (c == 2 || c == 5))) // Key positions  
            BlockData(row: r, col: c, health: 3)
          else if (r == 2 && (c == 1 || c == 6)) // Side guards
            BlockData(row: r, col: c, health: 2)
          else if (r == 2 && (c == 3 || c == 4)) // Core
            BlockData(row: r, col: c, health: 3)
          else if ((r + c) % 2 == 0) // Fill remaining with pattern
            BlockData(row: r, col: c, health: 1)
        ],
    ],
  ),
];
