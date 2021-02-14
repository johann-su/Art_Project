import org.openkinect.processing.*;
// Serial Libary for communication between esp and computer
import processing.serial.*;

Flock flock;

Serial port;

boolean linux = true;
// int screenX = 1440;
int screenX = 1250;
int speed = 0;
int size = 5;
int boidspeed = 5;
float weight = 0.20;
int amount = 400;
int schwanz = 20;

// All things for autoMode
int speedAuto = 0;
float weightAuto = 0;
int schwanzAuto = 0;
int amountAuto;
int[] states;
int timer;
int timer2;
boolean radomMode = false;
// End autoMode requirements

color boidColor = color(200);
color tailColor = color(255, 0, 255);
//color boidColor = color(0, 0, 0);
//color tailColor = color(0, 0, 0);
color backgroundColor = color(0);// color(255, 255, 255);

boolean display = true;
boolean sparn = true;
int sparnCount = 40;
ArrayList<Boid> boids;

void settings() {
  if(linux)
  {
    System.setProperty("jogl.disable.openglcore", "true");
  }

 //fullScreen(P3D);
 size(500, 500, P3D);
}

void setup() {
   frameRate(60);
   
  // size(1920,1080, P3D);

  flock = new Flock();
  // Add an initial set of boids into the system
  for (int i = 0; i < 1; i++) {
    flock.addBoid(new Boid(width/2, height/2));
  }
  
  // print all available serial ports
  printArray(Serial.list());
  
  // Create connection on port specified with esp
  port = new Serial(this, "/dev/cu.usbserial-0001", 9600);
}

void draw() {
  
  // print serial input
  while (port.available() > 0) {
    port.buffer(3);
    int inByte = port.read();
    println(inByte);
  }
  
  background(backgroundColor);
  
  // Show the image
  if (display) {
   
    fill(0, 255, 255);
    text(frameRate, screenX-70, 75, 100);
    text("size: " + size, screenX-70, 95, 100);
    text("speed: " + boidspeed, screenX-70, 115, 100);
    text("weight: " + weight, screenX-70, 135, 100);
    text("tail: " + schwanz, screenX-70, 155, 100);
    text("total: " + boids.size(), screenX-70, 175, 100);
    text("sparn: " + sparnCount, screenX-70, 195, 100);
  }
  

  // println("depth", v1.z);
  fill(50, 100, 250, 200);
  noStroke();

  //  println("wert",Math.round(map(v1.z,500,tracker.getThreshold(),6,0)));
 
  // if this mode is enabled, the boids are getting radoms specs
  if(millis() > timer + 5000 && radomMode){
    speedAuto = int(random(1 , 5));
    weightAuto = random(-1.5 , 0.7);
    schwanzAuto = int(random(10, 100));
    amountAuto = int(random(50, 250));
    //states[0] = int(random(0,1));
    //states[1] = int(random(0,1));
    //states[2] = int(random(0,1));
    timer = millis();
    
    for (Boid b : boids) {
      b.maxspeed = speedAuto;
      b.maxforce = weightAuto;
    }
    schwanz = schwanzAuto;
    amount = amountAuto;
    
    for (int i=0; i < 2; i++) {
      if (flock.amount() > amount) {
        flock.deleteBoid();
      } 
      if (flock.amount() < amount) {
        flock.addBoid(new Boid(random(0, screenX), random(0, 725)));
      }
    }
  }

  flock.run();
}

// Adjust the threshold with key presses
void keyPressed() {
 
  if (key == CODED) {
    if (keyCode == UP) {
     sparnCount ++; 
     
    } else if (keyCode == DOWN) {
    if(sparnCount >= 2){
    sparnCount -= 1;
    }
     
    } else if (keyCode == RIGHT) {
      display = true;
    } else if (keyCode == LEFT) {
      display = false;
    }
  } else {
    //println("key: ", key);
    if (key == '1') {
      //print("up");
      size -= 1;
      for (Boid b : boids) {
        b.r -= 1;
      }
    } else if (key == '2') {
      size += 1;
      for (Boid b : boids) {
        b.r += 1;
      }
    } else if (key == '3') {
      boidspeed -= 1;
      for (Boid b : boids) {
        b.maxspeed -= 1;
      }
    } else if (key == '4') {
      boidspeed += 1;
      for (Boid b : boids) {
        b.maxspeed += 1;
      }
    } else if (key == '5') {
      weight -= 0.10;
      for (Boid b : boids) {
        b.maxforce -= 0.10;
      }
    } else if (key == '6') {
      weight += 0.10;
      for (Boid b : boids) {
        b.maxforce += 0.10;
      }
    } else if (key == '7') {
      if (amount <= 50) {
      } else {
        amount -= 50;
        println("amount: ", amount);
      }
    } else if (key == '8') {
      print("Hallo es geht");
      amount += 50;
    } else if (key == '9') {
      schwanz -= 2;
    } else if (key == '0') {
      schwanz += 2;
    }
    // stop sparning
    else if (key == 'q') {
      schwanz = 1000;
    } else if (key == ' ') {
      size = 5;
      boidspeed = 5;
      weight = 0.20;
      schwanz = 20;
      boids.clear();
    }
    else if (key == 'a') {
      // attetion do not know if that the right way of doing it
     radomMode = !radomMode;
    } else if (key == 'c') {
      background(backgroundColor);
      boidColor = color(random(1, 255), random(1, 255), random(1, 255));
      tailColor = color(random(1, 255), random(1, 255), random(1, 255));
    } else {
    }
  }
}
// Add a new boid into the System
void mousePressed() {
  for (int i=0; i < sparnCount; i++) {
    flock.addBoid(new Boid(mouseX, mouseY));
    println(amount);
    while (flock.amount() > amount) {
      flock.deleteBoid();
    }
  }
}

// The Flock (a list of Boid objects)

class Flock {
  // An ArrayList for all the boids
  // ArrayList<Boid> boids;
  Flock() {
    boids = new ArrayList<Boid>(); // Initialize the ArrayList
  }

  void run() {
    for (Boid b : boids) {
      b.run(boids);  // Passing the entire list of boids to each boid individually
    }
  }

  void addBoid(Boid b) {
    boids.add(b);
  }

  void deleteBoid() {
    if (boids.size() <= 1) {
    } else {
      boids.remove(1);
    }
  }
  int amount() {
    return boids.size();
  }
}




// The Boid class

class Boid {

  PVector position;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;           // Maximum steering force
  float maxspeed;           // Maximum speed
  ArrayList<PVector> trail = new ArrayList<PVector>(); // a colored trail

  Boid(float x, float y) {
    acceleration = new PVector(0, 0);

    // This is a new PVector method not yet implemented in JS
    // velocity = PVector.random2D();

    // Leaving the code temporarily this way so that this example runs in JS
    float angle = random(TWO_PI);
    velocity = new PVector(cos(angle), sin(angle));
    position = new PVector(x, y);
    r = size;
    maxspeed = boidspeed;
    maxforce = weight;
  }

  void run(ArrayList<Boid> boids) {
    flock(boids);
    update();
    borders();
    render();
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
  }

  // We accumulate a new acceleration each time based on three rules
  void flock(ArrayList<Boid> boids) {
    PVector sep = separate(boids);   // Separation
    PVector ali = align(boids);      // Alignment
    PVector coh = cohesion(boids);   // Cohesion
    // Arbitrarily weight these forces
    sep.mult(1.5);
    ali.mult(1.0);
    coh.mult(1.0);
    // Add the force vectors to acceleration
    applyForce(sep);
    applyForce(ali);
    applyForce(coh);
  }

  void drawTail(ArrayList<PVector> positions) {
    int i = 1;
    for (PVector p : positions) {
      if ((i % 2) ==0) {
        if (i < 10) {
          noStroke();
          fill(tailColor, map(i, 0, 10, 0, 255));
          ellipse(p.x, p.y, r, r);
        } else {
          noStroke();
          fill(tailColor);
          ellipse(p.x, p.y, r, r);
        }
        // translate(p.x, p.y);
        // println("position: ", p);
      }
      //  println("i: ", i);
      i ++;
    }
  }

  // Method to update position
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    // add position to trail 
    position.add(velocity);

    trail.add(new PVector(position.x, position.y));
    // cut tail if size is to long
    if (trail.size() > schwanz) {
      trail.remove(0);
    }
    //draw tail
    drawTail(trail);



    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, position);  // A vector pointing from the position to the target
    // Scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);

    // Above two lines of code below could be condensed with new PVector setMag() method
    // Not using this method until Processing.js catches up
    // desired.setMag(maxspeed);

    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force
    return steer;
  }

  void render() {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D() + radians(90);
    // heading2D() above is now heading() but leaving old syntax until Processing.js catches up

    fill(boidColor, 100);
    stroke(boidColor);
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);
    beginShape(TRIANGLES);
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape();
    popMatrix();
  }

  // Wraparound
  void borders() {
    if (position.x < -r) position.x = width+r;
    if (position.y < -r) position.y = height+r;
    if (position.x > width+r) position.x = -r;
    if (position.y > height+r) position.y = -r;
  }

  // Separation
  // Method checks for nearby boids and steers away
  PVector separate (ArrayList<Boid> boids) {
    float desiredseparation = 25.0f;
    PVector steer = new PVector(0, 0, 0);
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < desiredseparation)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d);        // Weight by distance
        steer.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      steer.div((float)count);
    }

    // As long as the vector is greater than 0
    if (steer.mag() > 0) {
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // steer.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      steer.normalize();
      steer.mult(maxspeed);
      steer.sub(velocity);
      steer.limit(maxforce);
    }
    return steer;
  }

  // Alignment
  // For every nearby boid in the system, calculate the average velocity
  PVector align (ArrayList<Boid> boids) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.velocity);
        count++;
      }
    }
    if (count > 0) {
      sum.div((float)count);
      // First two lines of code below could be condensed with new PVector setMag() method
      // Not using this method until Processing.js catches up
      // sum.setMag(maxspeed);

      // Implement Reynolds: Steering = Desired - Velocity
      sum.normalize();
      sum.mult(maxspeed);
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      return steer;
    } else {
      return new PVector(0, 0);
    }
  }

  // Cohesion
  // For the average position (i.e. center) of all nearby boids, calculate steering vector towards that position
  PVector cohesion (ArrayList<Boid> boids) {
    float neighbordist = 50;
    PVector sum = new PVector(0, 0);   // Start with empty vector to accumulate all positions
    int count = 0;
    for (Boid other : boids) {
      float d = PVector.dist(position, other.position);
      if ((d > 0) && (d < neighbordist)) {
        sum.add(other.position); // Add position
        count++;
      }
    }
    if (count > 0) {
      sum.div(count);
      return seek(sum);  // Steer towards the position
    } else {
      return new PVector(0, 0);
    }
  }
}
