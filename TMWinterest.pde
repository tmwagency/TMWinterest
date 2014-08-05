import processing.serial.*;
import processing.video.*;
import ddf.minim.*; 


// init the audio
Minim minim; 
AudioSample click;
AudioPlayer song;

// define vars
Serial myPort; // The serial port:
// GSCapture cam;
Capture cam;
String lines[];
String filepath;
String uFilename;
String filename;
Boolean picTaken = false;

void setup() 
{
  // size(720, 1200);
  size(720, 1280);
  noLoop();

  String lines[] = loadStrings("path.txt"); // file path for images
  filepath = lines[0];
  // set up serial
  if (Serial.list().length > 1) {
    myPort = new Serial(this, Serial.list()[1], 9600);
  }

  // set up audio
  minim = new Minim(this); 
  click = minim.loadSnippet("camera_click.wav");
  song = minim.loadSnippet("arm.wav");
  // cam = new GSCapture(this, 1200, 720);
  cam = new Capture(this, 1280, 720);
}

void draw() {

  if (cam.available()) {
    cam.read();
  }
  translate(720, 0);
  rotate(PI/2);
  image(cam, 0, 0);
}

void serialEvent(Serial p) {

  int inBuffer = Integer.parseInt(trim(myPort.readString()));

  switch(inBuffer) {
  case 5:
    if (!song.isPlaying()) {
      song.rewind();
      song.play();
    }
    cam.start();
    break;
  case 1:
    takePhoto(1);
    break;
  case 2:
    takePhoto(2);
    break;
  case 3:
    takePhoto(3);
    break;
  case 4:
    takePhoto(4);
    break;
  }
}

void takePhoto(int pinboardNum) {
  
  if (!click.isPlaying()) {
    click.rewind();
    click.play();
  }

  redraw();
  delay(200);
  // save the image locally
  PImage cropSave = get(0, 200, 720, 1080); 
  uFilename = filepath + "pin-" + getDate() + "_" + pinboardNum + ".jpg";
  cropSave.save(uFilename);


  delay(17000);
  cam.stop();
}

// create a timestamp for the filename
String getDate() {
  String mth = String.valueOf(month());
  String d = String.valueOf(day());
  String s = String.valueOf(second());  // Values from 0 - 59
  String m = String.valueOf(minute());  // Values from 0 - 59
  String h = String.valueOf(hour());    // Values from 0 - 23
  return mth + "-" + d + "---" + h + "-" + m + "-" + s;
}

public void stop() {
  click.close();
  song.close();
  super.stop();
}
