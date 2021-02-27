// the input device used; available types: button, potentiometer, ir-distance, ultrasonic-distance, movement, photoresistor, air, microphone, joystick
String type = "button";

// Rotary Encoder
int inputCLK = 19;
int inputDT = 18;
int rotSW = 23;

// Button
int buttonPin = 15;

// Joystick
int inputVRx = 16;
int inputVRy = 17;
int joySW = 18;

// Microphone
int sound = 4;

// Movement
int inputMov = 2;

// Air
int inputAir = 15;

void setup() {
  //Rotary Encoder
  pinMode(inputCLK, INPUT);
  pinMode(inputDT, INPUT);
  pinMode(rotSW, INPUT);
  
  // Button
  pinMode(buttonPin, INPUT);
  
  //Joystick
  pinMode(inputVRx, INPUT);
  pinMode(inputVRy, INPUT);
  pinMode(joySW, INPUT);
  
  // Microphone
  pinMode(sound, INPUT);
  
  // Movement
  pinMode(inputMov, INPUT);
  
  // Air
  pinMode(inputAir, INPUT);
  
  Serial.begin(9600);
}

void loop() {
  if (type == "potentiometer") {
    // Rotary Encoder
    Serial.write(digitalRead(inputCLK));
    Serial.write(digitalRead(inputDT));
    Serial.write(digitalRead(rotSW));
  } else if (type == "button") {
    // Button
    Serial.write(digitalRead(buttonPin));
  } else if (type == "joystick") {
    // Joystick
    Serial.write(digitalRead(inputVRx));
    Serial.write(digitalRead(inputVRy));
    Serial.write(digitalRead(joySW));
  } else if (type == "microphone") {
    // Microphone
    Serial.write(digitalRead(sound));
  } else if (type == "movement") {
    // Movement
    Serial.write(digitalRead(inputMov));
  } else if (type == "air") {
    // Air
    Serial.write(digitalRead(inputAir));
  }
}
