int state = 0;      
int score = 0;      
int startTime;      
int duration = 30;  
int catchCount = 0;

float px = 350;      
float py = 175;      
float pSize = 20;    
float pSpeed = 6;    

float hx = 350;      
float hy = 175;      
float ease = 0.10;   

float o1x = 100, o1y = 100, o1Size = 10, o1xs = 4, o1ys = 3;   
float o2x = 400, o2y = 300, o2Size = 10, o2xs = -3, o2ys = 5; 
float gx, gy, gSize = 12, gxs, gys;
boolean goldActive = false;

boolean trails = false; 

void setup() {
  size(800, 600); 
}

void draw() {
  if (state == 0) {
    background(0);
    textAlign(CENTER, CENTER);
    fill(255);
    textSize(40);
    text("CATCH THE ORB\n\nArrows to Move\n'T' for Trails\n\nENTER to Start", width/2, height/2);
  } else if (state == 1) {
    if (!trails) {
      background(0); 
    } else {
      fill(0, 45);   
      noStroke();
      rect(0, 0, width, height);
    }
    
    int timeLeft = duration - (millis() - startTime) / 1000;
    if (timeLeft <= 0) state = 2; 

    if (keyPressed) {
      if (keyCode == UP)    py -= pSpeed;
      if (keyCode == DOWN)  py += pSpeed;
      if (keyCode == LEFT)  px -= pSpeed;
      if (keyCode == RIGHT) px += pSpeed;
    }
    
    px = constrain(px, pSize, width - pSize);
    py = constrain(py, pSize, height - pSize);
    
    hx += (px - hx) * ease;
    hy += (py - hy) * ease;
    
    o1x += o1xs; o1y += o1ys;
    if (o1x > width - o1Size || o1x < o1Size) o1xs *= -1;
    if (o1y > height - o1Size || o1y < o1Size) o1ys *= -1;

    o2x += o2xs; o2y += o2ys;
    if (o2x > width - o2Size || o2x < o2Size) o2xs *= -1;
    if (o2y > height - o2Size || o2y < o2Size) o2ys *= -1;

    if (dist(px, py, o1x, o1y) < pSize + o1Size) {
      score++;
      catchCount++;
      o1x = random(o1Size, width - o1Size);
      o1y = random(o1Size, height - o1Size);
      o1xs *= 1.1; o1ys *= 1.1;
      checkGold();
    }

    if (dist(px, py, o2x, o2y) < pSize + o2Size) {
      score++;
      catchCount++;
      o2x = random(o2Size, width - o2Size);
      o2y = random(o2Size, height - o2Size);
      o2xs *= 1.1; o2ys *= 1.1;
      checkGold();
    }

    if (goldActive) {
      gx += gxs; gy += gys;
      if (gx > width - gSize || gx < gSize) gxs *= -1;
      if (gy > height - gSize || gy < gSize) gys *= -1;
      
      fill(255, 215, 0);
      ellipse(gx, gy, gSize*2, gSize*2);
      
      if (dist(px, py, gx, gy) < pSize + gSize) {
        score += 3;
        goldActive = false;
      }
    }
    
    fill(255, 204, 0, 150);
    ellipse(hx, hy, 16, 16);
    fill(255, 204, 0);
    ellipse(px, py, pSize*2, pSize*2);
    
    fill(255, 100, 100);
    ellipse(o1x, o1y, o1Size*2, o1Size*2);
    fill(160, 32, 240);
    ellipse(o2x, o2y, o2Size*2, o2Size*2);
    
    fill(255);
    textSize(18);
    textAlign(LEFT, TOP);
    text("Score: " + score, 20, 20);
    text("Time Left: " + timeLeft, 20, 45);
    text("Trails: " + (trails ? "ON" : "OFF"), 20, 70);
  } else if (state == 2) {
    background(100, 0, 0);
    textAlign(CENTER, CENTER);
    fill(255);
    textSize(32);
    text("GAME OVER!\nFinal Score: " + score + "\n\nPress R to Restart", width/2, height/2);
  }
}

void checkGold() {
  if (catchCount >= 5) {
    goldActive = true;
    gx = random(gSize, width - gSize);
    gy = random(gSize, height - gSize);
    gxs = random(-6, 6);
    gys = random(-6, 6);
    catchCount = 0;
  }
}

void keyPressed() {
  if (state == 0 && keyCode == ENTER) {
    state = 1;        
    score = 0;
    catchCount = 0;
    goldActive = false;
    startTime = millis(); 
    o1xs = 4; o1ys = 3;
    o2xs = -3; o2ys = 5;
  }
  if (state == 2 && (key == 'r' || key == 'R')) {
    state = 0;        
  }
  if (key == 't' || key == 'T') {
    trails = !trails; 
  }
}
