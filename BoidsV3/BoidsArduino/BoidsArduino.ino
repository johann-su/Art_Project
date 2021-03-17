
// Github Code
// defines pins numbers
const int StrigPin = 8;
const int SechoPin = 9;
const int StrigPin1 = 10;
const int SechoPin1 = 11;
const int StrigPin2 = 12;
const int SechoPin2 = 13;
int distanceSet = 50;
// defines variables
long Speedduration;
long distance, duration;
int Speed;
int SensorSpeed = distanceSet  + 1;
int weight = 2;
int SensorWeight= distanceSet + 1;
int tail = 20;
int SensorTail = distanceSet + 1;
void setup() {
pinMode(StrigPin, OUTPUT); // Sets the trigPin as an Output
pinMode(SechoPin, INPUT);
pinMode(StrigPin1, OUTPUT); // Sets the trigPin as an Output
pinMode(SechoPin1, INPUT);// Sets the echoPin as an Input
pinMode(StrigPin2, OUTPUT); // Sets the trigPin as an Output
pinMode(SechoPin2, INPUT);
Serial.begin(9600); // Starts the serial communication
}

void loop() {
SonarSensor(StrigPin, SechoPin);
SensorSpeed = distance;
if(SensorSpeed <= distanceSet){
  Speed = SensorSpeed;
}
SonarSensor(StrigPin1, SechoPin1);
SensorWeight = distance;
if(SensorWeight <= distanceSet){
  weight = SensorWeight;
}
SonarSensor(StrigPin2, SechoPin2);
SensorTail = distance;
if(SensorTail <= distanceSet){
  tail = SensorTail;
}


// Calculating the distance

// Prints the distance on the Serial Monitor
byte Tx_Data[6];
if(SensorSpeed <= distanceSet || SensorWeight <= distanceSet || SensorTail <= distanceSet){
  Tx_Data[0] = Speed >> 8 & 0xff;
  Tx_Data[1] = Speed& 0xff;
  Tx_Data[2] = weight >> 8 & 0xff;
  Tx_Data[3] = weight& 0xff;
  Tx_Data[4] = tail >> 8 & 0xff;
  Tx_Data[5] = tail& 0xff;
 
  
  Serial.write(Tx_Data,6);
  
}
}
void SonarSensor(int trigPin,int echoPin)
{
digitalWrite(trigPin, LOW);
delayMicroseconds(2);
digitalWrite(trigPin, HIGH);
delayMicroseconds(10);
digitalWrite(trigPin, LOW);
duration = pulseIn(echoPin, HIGH);
distance = duration * 0.034/2;

}
