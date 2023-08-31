import processing.opengl.*;
float angle = 0;
float zoom = 1.0;
float rotx = PI/4;
float roty = PI/4;
int counter = 30; // Sayaç başlangıç değeri
int counter2=1;//Yem sayısı
float offsetX, offsetY; // Titreme efekti için konum ofseti
float ghostMoveInterval = 250; // Hayaletlerin hareket etme aralığı (1/4 saniye)
float lastGhostMoveTime = 0; // Son hayalet hareket zamanı
boolean collision = false;
PShape circle1, circle2, circle3;

void setup() {
  fullScreen(P3D);
// İlk küre-pacman
  circle1 = createShape();
  circle1.beginShape(TRIANGLE_FAN);
  circle1.noStroke();
  circle1.fill(255, 255, 0);
  circle1.vertex(0, 0, 0);
  int n1 = 50;
  float radius1 = 25;
  for (int i = 0; i <= n1; i++) {
    float x = sin(i * TWO_PI / n1) * radius1;
    float y = cos(i * TWO_PI / n1) * radius1;
    circle1.vertex(x, y, 0);
  }
  circle1.endShape();
  // İkinci küre-yem
  circle2 = createShape();
  circle2.beginShape(TRIANGLE_FAN);
  circle2.noStroke();
  circle2.fill(0, 0, 255);
  circle2.vertex(0, 0, 0);
  int n2 = 50;
  float radius2 = 10;
  for (int i = 0; i <= n2; i++) {
    float x = sin(i * TWO_PI / n2) * radius2;
    float y = cos(i * TWO_PI / n2) * radius2;
    circle2.vertex(x, y, 0);
  }
  circle2.endShape();

  // Üçüncü küre-hayalet
  circle3 = createShape();
  circle3.beginShape(TRIANGLE_FAN);
  circle3.noStroke();
  circle3.fill(255, 0, 0);
  circle3.vertex(0, 0, 0);
  int n3 = 50;
  float radius3 = 25;
  for (int i = 0; i <= n3; i++) {
    float x = sin(i * TWO_PI / n3) * radius3;
    float y = cos(i * TWO_PI / n3) * radius3;
    circle3.vertex(x, y, 0);
  }
  circle3.endShape();
}
int pacmanX = 0;// Pacman 1'in başlangıç X konumu
int pacmanY = 0;// Pacman 1'in başlangıç X konumu

int ghost1X = 14; // Hayalet 1'in başlangıç X konumu
int ghost1Y = 8; // Hayalet 1'in başlangıç Y konumu

int ghost2X = 14; // Hayalet 2'nin başlangıç X konumu
int ghost2Y = 8; // Hayalet 2'nin başlangıç Y konumu

int ghost3X = 14; // Hayalet 3'nin başlangıç X konumu
int ghost3Y = 8; // Hayalet 3'nin başlangıç Y konumu
int[][] map = {
  {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
  {1,0,1,0,0,0,0,0,1,0,0,1,0,0,1},
  {1,0,1,1,1,1,1,1,1,1,0,0,0,1,1},
  {1,1,1,0,1,0,0,0,0,1,1,1,1,1,0},
  {1,0,1,0,1,0,1,1,0,1,0,1,0,0,0},
  {1,0,1,0,1,0,1,0,0,1,0,1,1,1,0},
  {1,0,1,0,0,0,1,1,1,1,0,1,0,0,0},
  {1,1,1,0,0,1,1,0,1,0,0,1,1,1,1},
  {1,0,1,1,1,1,0,0,1,1,1,1,0,0,1},
};
boolean messagetable=false;
boolean foodcontrol=false;
boolean messagetable2=false;
void draw() {
  background(0);
  lights();
  camera(width/2.0, height/3.5, (height/2.0) / tan(PI*32.0 / 180.0), width/2, height/2.0, 0, 0, 1,0 );
translate(width/4 , height/3 );
  scale(zoom);
  rotateX(rotx);
  rotateY(roty);
  translate(-width/4, -height/3);
  // Hayaletlerin hareket etme kontrolü
  if (millis() - lastGhostMoveTime >= ghostMoveInterval) {
    lastGhostMoveTime = millis();
    updateGhostPosition();
  }
  // Hayaletlerin pacman ile çarpışma kontrolü
  if (pacmanX == ghost1X && pacmanY == ghost1Y) {
    collision = true;
  } else if (pacmanX == ghost2X && pacmanY == ghost2Y) {
    collision = true;
  } else if (pacmanX == ghost3X && pacmanY == ghost3Y) {
    collision = true;
  } else {
    collision = false;
  }
  
  // Çarpışma durumuna göre mesajı gösterme
  if (collision) {
    fill(255, 0, 0);
    textSize(50);
    textAlign(CENTER, CENTER);
    text("Game Over! You collided with a ghost.", width/2, height/2-220);
    noLoop(); // Oyun döngüsünü durdurma
  }
  //pacmanin yemi yediği an
  if (pacmanX == 7 && pacmanY == 4) {
    foodcontrol=true;
    messagetable=true;
    counter2=0;
}
//oyunun bitiş anı
if (pacmanX == 14 && pacmanY == 8) {
  if(foodcontrol==true){ 
    messagetable=false;
    messagetable2=true;} 
    else if(foodcontrol==false){
    fill(255,0,0); 
    textSize(50); 
    textAlign(CENTER, CENTER); // Yazıyı merkeze hizala
    text("You didn't eat the food,you have note enough energy for win the game :(",  width/2, height/2-270); // "Bravo" mesajını ekranda göster
    }
}
if(messagetable2==true){
  messagetable=false;  
  fill(255,0,0); 
    textSize(50); 
    textAlign(CENTER, CENTER); // Yazıyı merkeze hizala
    print("You win the game!");
    text("Congratulations!! YOU WIN!", width/2, 200); // "Bravo" mesajını ekranda göster
    noLoop();
  
}
if(messagetable==true){
    fill(255); 
    textSize(30); 
    textAlign(CENTER, CENTER); // Yazıyı merkeze hizala
    text("Congratulations!! You ate the food lets go to the finish point for win!",  width/2, height/2-300); // "Bravo" mesajını ekranda göster
}
// Sayaç sıfıra ulaştığında "Time is up!" mesajını yazdır
  if (counter == 0) {
    fill(#2EB4A3);
    textSize(60);
    messagetable=false;
    messagetable2=false;
    text("Time is up!", width/2, height/2-260);
    print("You lose the game cause of Time!");
    noLoop();
  }
  translate((width/4),(height/3));
  // yem sayısı değerini yazdır
  fill(#2EB4A3);
  textSize(32);
  textAlign(CENTER, CENTER);
  textSize(50);
  text("Food score:"+counter2, 100, 500);
  textSize(40);
  // Sayaç değerini yazdır
  fill(#2EB4A3);
  textSize(32);
  textAlign(CENTER, CENTER);
  textSize(120);
  text(counter, 375, 500);
  textSize(40);
  // Her bir çerçevede 1 saniye azalt
  if (frameCount % 60 == 0 && counter > 0) {
    counter--;
  }

  
  // Başlangıç metnini ekle
  textSize(35);
  fill(#FCAE03); 
  text("Start", -15, 0);

  // Bitiş yazısını titret
  offsetX = random(-5, 5);
  offsetY = random(-5, 5); 
  fill(#FCAE03); 
  textSize(45);
  text("Finish", 680 + offsetX, 415 + offsetY);
  // labirenti çiz
  for (int i = 0; i < map.length; i++) {
    for (int j = 0; j < map[i].length; j++) {
      if (map[i][j] == 0) {
        box(50);
      } else {
        pushMatrix();
        translate(j*50, i*50, 0);
        noFill();
        stroke(#0FFF71);
        box(50);
        popMatrix();
      }
    }
  }
//--------------
// İlk küre-pacman
pushMatrix();
translate(pacmanX * 50, pacmanY * 50);
rotateY(angle);
angle += 0.01;
shape(circle1);
fill(0);
textSize(20);
text("pacman", -30, 0);
popMatrix();
if(foodcontrol==false){
// İkinci küre-yem
pushMatrix();
translate(350, 200);
rotateY(angle);
angle += 0.01;
shape(circle2);
fill(0);
textSize(20);
text("food", -15+offsetX/2, 0+offsetY/2);
popMatrix();
}
// Üçüncü küre-hayalet
pushMatrix();
translate(700, 400);
translate(-(14-ghost1X) * 50, -(8-ghost1Y) * 50);
rotateY(angle);
angle += 0.01;
shape(circle3);
fill(0);
textSize(20);
text("ghost1", -30, 0);
popMatrix();
// dördüncü küre-2. hayalet
pushMatrix();
translate(700, 400);
translate(-(14-ghost2X) * 50, -(8-ghost2Y) * 50);
rotateY(angle);
angle += 0.01;
shape(circle3);
fill(0);
textSize(20);
text("ghost2", -30, 0);
popMatrix();
// Dördüncü küre 3.-hayalet
pushMatrix();
translate(700, 400);
translate(-(14-ghost3X) * 50, -(8-ghost3Y) * 50);
rotateY(angle);
angle += 0.01;
shape(circle3);
fill(0);
textSize(20);
text("ghost3", -30, 0);
popMatrix();
}
void keyPressed() {
  if (keyCode == UP || key == 'w' || key == 'W') {
    // Yukarı tuşuna veya W tuşuna basıldığında Pacman'ı yukarı hareket ettir
    if (pacmanY > 0 && map[pacmanY - 1][pacmanX] == 1) {
      pacmanY--;
      updateGhostPosition();
    }
  } else if (keyCode == DOWN || key == 's' || key == 'S') {
    // Aşağı tuşuna veya S tuşuna basıldığında Pacman'ı aşağı hareket ettir
    if (pacmanY < map.length - 1 && map[pacmanY + 1][pacmanX] == 1) {
      pacmanY++;
      updateGhostPosition();
    }
  } else if (keyCode == LEFT || key == 'a' || key == 'A') {
    // Sol tuşuna veya A tuşuna basıldığında Pacman'ı sola hareket ettir
    if (pacmanX > 0 && map[pacmanY][pacmanX - 1] == 1) {
      pacmanX--;
      updateGhostPosition();
    }
  } else if (keyCode == RIGHT || key == 'd' || key == 'D') {
    // Sağ tuşuna veya D tuşuna basıldığında Pacman'ı sağa hareket ettir
    if (pacmanX < map[pacmanY].length - 1 && map[pacmanY][pacmanX + 1] == 1) {
      pacmanX++;
      updateGhostPosition();
    }
  }
  else if ( key == 'p' || key == 'P') {
    // P tuşuna basıldığında oyunu bitir.
      
      
      textSize(60);
      fill(255,0,0);
      print("You pressed the P key.So the game finished automatically.");
      text("You pressed the P key.So the game finished automatically.", width/2-230,height/2-200);
      noLoop();
    
  }
}
void updateGhostPosition() {
  // Hayalet 1'in hareketini güncelle
  int ghost1Direction =(int)random(6); // 0: Yukarı, 1: Aşağı, 2: Sol, 3: Sağ, 4:Sol, 5:Yukarı

  if ((ghost1Direction==5||ghost1Direction == 0) && ghost1Y > 0 && map[ghost1Y - 1][ghost1X] == 1) {
    ghost1Y--;
  } else if (ghost1Direction == 1 && ghost1Y < map.length - 1 && map[ghost1Y + 1][ghost1X] == 1) {
    ghost1Y++;
  } else if ((ghost1Direction==4||ghost1Direction == 2) && ghost1X > 0 && map[ghost1Y][ghost1X - 1] == 1) {
    ghost1X--;
  } else if (ghost1Direction == 3 && ghost1X < map[0].length - 1 && map[ghost1Y][ghost1X + 1] == 1) {
    ghost1X++;
  }

  // Hayalet 2'nin hareketini güncelle
  int ghost2Direction = (int)random(6); // 0: Yukarı, 1: Aşağı, 2: Sol, 3: Sağ 4:Sol, 5:Yukarı

  if ((ghost2Direction == 5||ghost2Direction == 0) && ghost2Y > 0 && map[ghost2Y - 1][ghost2X] == 1) {
    ghost2Y--;
  } else if (ghost2Direction == 1 && ghost2Y < map.length - 1 && map[ghost2Y + 1][ghost2X] == 1) {
    ghost2Y++;
  } else if ((ghost2Direction==4||ghost2Direction == 2) && ghost2X > 0 && map[ghost2Y][ghost2X - 1] == 1) {
    ghost2X--;
  } else if (ghost2Direction == 3 && ghost2X < map[0].length - 1 && map[ghost2Y][ghost2X + 1] == 1) {
    ghost2X++;
  }
  
  // Hayalet 3'in hareketini güncelle
  int ghost3Direction =(int)random(4); // 0: Yukarı, 1: Aşağı, 2: Sol, 3: Sağ

  if (ghost3Direction == 0 && ghost3Y > 0 && map[ghost3Y - 1][ghost3X] == 1) {
    ghost3Y--;
  } else if (ghost3Direction == 1 && ghost3Y < map.length - 1 && map[ghost3Y + 1][ghost3X] == 1) {
    ghost3Y++;
  } else if (ghost3Direction == 2 && ghost3X > 0 && map[ghost3Y][ghost3X - 1] == 1) {
    ghost3X--;
  } else if (ghost3Direction == 3 && ghost3X < map[0].length - 1 && map[ghost3Y][ghost3X + 1] == 1) {
    ghost3X++;
  }
}
void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  zoom += -e*0.1;
}
void mouseDragged() {
  float rate = 0.01;
  rotx += (pmouseY-mouseY) * rate;
  roty += (mouseX-pmouseX) * rate;
}
