# 🎮 Brick Breaker Game  
**Advanced Game Development School Project**  

---

## 🖍 Project Overview  
This is a **Brick Breaker** game built using **Flutter** and the **Flame Engine**. The game showcases interactive gameplay mechanics, collision detection, and dynamic ball and paddle controls. It was created as part of an **Advanced Game Development** course to demonstrate proficiency in game development concepts, physics-based interactions, and event-driven programming.

---

## 🚀 Features  

- **Gameplay Modes**: Welcome screen, active gameplay, game over, and win states.  
- **Dynamic Ball Movement**: Balls bounce off walls, bricks, and the paddle with accurate collision detection.  
- **Power-Ups**: Option to spawn multiple balls during gameplay.  
- **Keyboard and Touch Support**: Move the paddle using arrow keys or touch controls.  
- **Score Tracking**: A live score system tracks your progress in real-time.  
- **Responsive Design**: The game adapts to different screen sizes using fixed camera resolution.  
- **Customizable Difficulty**: Adjust game parameters like ball speed, brick layout, and paddle size.  

---

## 🛠️ Technologies Used  

- **Flutter**: Cross-platform app development framework.  
- **Flame Engine**: A game development framework for Flutter.  
- **Dart**: Programming language powering the game logic.  
- **Flame Collision Detection**: Manages interactions between game objects.  

---

## 🎮 How to Play  

1. **Start the Game**:  
   - Click or tap on the screen.  
   - Alternatively, press `Space` or `Enter` on the keyboard.  

2. **Move the Paddle**:  
   - Use the **Left Arrow** key to move left.  
   - Use the **Right Arrow** key to move right.  

3. **Objective**:  
   - Bounce the ball off the paddle to break all the bricks.  
   - Avoid letting the ball fall off the bottom of the screen.  

4. **Win Condition**:  
   - Break all the bricks.  

5. **Game Over**:  
   - If the ball falls below the paddle.  

---

## 🛠️ Setup Instructions  

Follow these steps to set up and run the project locally:

1. **Clone the Repository**:  
   ```bash
   git clone https://github.com/yourusername/brick-breaker-game.git
   cd brick-breaker-game
   ```

2. **Install Flutter Dependencies**:  
   Ensure that Flutter is installed on your system. Then run:  
   ```bash
   flutter pub get
   ```

3. **Run the Game**:  
   ```bash
   flutter run
   ```

4. **Enjoy the Game!**  

---

## ⚙️ Configuration  

You can customize the following parameters in `config.dart`:  

| Parameter           | Description                          | Default Value   |
|----------------------|--------------------------------------|-----------------|
| `gameWidth`         | Width of the game screen             | `800`           |
| `gameHeight`        | Height of the game screen            | `600`           |
| `ballRadius`        | Radius of the ball                   | `10.0`          |
| `batWidth`          | Width of the paddle (bat)            | `100.0`         |
| `batHeight`         | Height of the paddle (bat)           | `20.0`          |
| `brickGutter`       | Space between bricks                 | `5.0`           |
| `difficultyModifier`| Adjust ball speed and difficulty     | `1.0`           |

---

## 🖼️ Screenshots  

| Welcome Screen                    | Gameplay                          |
|----------------------------------|----------------------------------|
| ![Welcome](assets/welcome.png)    | ![Gameplay](assets/gameplay.png)  |

---

## 🏫 About the Project  

This project was created as part of the **Advanced Game Development** course to demonstrate:  
- Implementing game states and overlays (welcome, game over, win).  
- Using Flame Engine for collision detection and rendering.  
- Handling keyboard and touch events for paddle control.  
- Managing score, spawning power-ups, and ball physics.  

Enjoy playing the game! 🕹️🚀  
