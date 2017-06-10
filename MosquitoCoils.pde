//MosquitoKiller.pde
//プログラミング演習発表
//2014/07/22
//3-24 斉藤絢基
//蚊を全滅させるプログラム

import ddf.minim.*;
import ddf.minim.signals.*;

Minim minim;
AudioOutput out;
SineWave sine;

float x=530;//煙初期位置x
float y=0;// 煙の初期位置y
float a=80;//消えゆく煙
float theta=1600;
float angle=1597;
float s, t;//火の位置
float katoriX, katoriY;
float[]cursorX=new float[30];//蚊のx座標
float[]cursorY=new float[30];//蚊のy座標
int[]flag=new int[30];//蚊が火の上を通過したとき flag[j]=0



void setup() {
  size(800, 700);
  minim = new Minim(this);
  out = minim.getLineOut(Minim.STEREO);
  sine = new SineWave(18000, 0.5, out.sampleRate());
  out.addSignal(sine);

  int i=0;
  while (i<30) {
    cursorX[i]=(int)random(80, 720);
    cursorY[i]=(int)random(80, 320);
    flag[i]=i;
    i++;
  }
}


void draw() {
  background(100);
  stroke(11, 142, 32);
  katori(mouseX, mouseY, 0, 1.0);

  int j=0;
  while (j<30) {
    //火
    strokeWeight(12);
    for (float i=1600; i>=angle; i--) {
      stroke(255, 0, 0);
      point(s, t);
      s=0.1*i*cos(radians(i))+mouseX+10;
      t=0.1*i*sin(radians(i))+mouseY;
    }


    //減っていく蚊取り線香
    strokeWeight(13);
    for (float i=1600; i>=theta; i--) {
      stroke(100);
      point(katoriX, katoriY);
      katoriX=0.1*i*cos(radians(i))+mouseX+10;
      katoriY=0.1*i*sin(radians(i))+mouseY;
    }
    angle=angle-0.01;
    theta=theta-0.01;


    //蚊、端にいったら逆側から出てくる。
    if (cursorX[j]>800) {
      cursorX[j]=0;
    } else if (cursorX[j]<0) {
      cursorX[j]=800;
    }
    if (cursorY[j]>700) {
      cursorY[j]=0;
    } else if (cursorY[j]<0) {
      cursorY[j]=700;
    }



    //蚊、やられる。
    //蚊が火の上にいたら
    if (cursorX[j]>s-3&&cursorX[j]<s+3&&cursorY[j]<t ) {
      flag[j]=0;
    }
    if (flag[j]==0) {
      strokeWeight(1);
      stroke(255, 0, 0);
      cursorX[j]=cursorX[j];
      cursorY[j]=cursorY[j]+5;
      Mosquito(cursorX[j], cursorY[j], 180, 0.1);
      if (cursorY[j]>680) {
        cursorX[j]=cursorX[j];
        cursorY[j]=680;
      }
    } else {
      strokeWeight(1);
      stroke(255);
      cursorX[j]=cursorX[j]+(int)random(-10, 10);
      cursorY[j]=cursorY[j]+(int)random(-10, 10);
      Mosquito(cursorX[j], cursorY[j], 0, 0.1);
    }

    j++;
  }
}



//蚊取り線香
void katori(float i, float j, float angle_deg, float scale_factor) {
  int offset_x=190;
  int offset_y=200;

  pushMatrix();
  translate(i, j);
  scale(scale_factor);
  rotate(radians(angle_deg));
  translate(-offset_x, -offset_y);


  int theta=0; 
  while (theta<=1600) {
    float x=0;
    float y=0;
    x=0.1*theta*cos(radians(theta))+200;
    y=0.1*theta*sin(radians(theta))+200;
    strokeWeight(10);
    point(x, y);
    theta=theta+1;
  }

  popMatrix();
}



//蚊
void Mosquito(float i, float j, float angle_deg, float scale_factor) {
  int offset_x=190;
  int offset_y=200;

  pushMatrix();
  translate(i, j);
  scale(scale_factor);
  rotate(radians(angle_deg));
  translate(-offset_x, -offset_y);


  arc(165, 80, 200, 130, radians(150), radians(165));
  line(68, 94, 55, 230);
  line(90, 100, 95, 210);

  fill(197, 227, 226, 10);

  beginShape();
  vertex(130, 130);
  vertex(250, 50);
  vertex(260, 30);
  vertex(230, 20);
  endShape(CLOSE);

  beginShape();
  vertex(130, 130);
  vertex(270, 70);
  vertex(280, 50);
  vertex(250, 40);
  endShape(CLOSE);

  beginShape();
  vertex(130, 130);
  vertex(50, 50);
  vertex(40, 30);
  vertex(70, 20);
  endShape(CLOSE);

  beginShape();
  vertex(130, 130);
  vertex(30, 70);
  vertex(20, 50);
  vertex(50, 40);
  endShape(CLOSE);



  fill(60, 60, 60);
  rotate(radians(30));
  translate(60, -140);
  ellipse(180, 180, 100, 30);

  rotate(radians(-30));
  translate(-130, 100);
  ellipse(140, 118, 40, 25);
  fill(255);
  ellipse(115, 115, 20, 20);
  triangle(113, 122, 117, 122, 108, 180);
  ellipse(100, 100, 30, 30);
  ellipse(130, 100, 30, 30);
  fill(0);
  ellipse(101, 105, 15, 15);
  ellipse(127, 106, 15, 15);

  noFill();
  arc(130, 60, 140, 130, radians(30), radians(80));
  arc(140, 60, 170, 130, radians(40), radians(80));
  line(191, 91, 195, 230);
  line(140, 125, 180, 150);
  line(180, 150, 150, 220);
  line(204, 100, 212, 225);

  popMatrix();
}

void stop()
{
  out.close();
  minim.stop();
  super.stop();
}

