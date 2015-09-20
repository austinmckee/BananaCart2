int forceSensor0 = A0;
int forceSensor1 = A1;
int forceSensor2 = A2;
int forceSensor3 = A3;

int force0 = 0;
int force1 = 0;
int force2 = 0;
int force3 = 0;
int sumForces = 0;


void setup() {
    pinMode(forceSensor0, INPUT);
    pinMode(forceSensor1, INPUT);
    pinMode(forceSensor2, INPUT);
    pinMode(forceSensor3, INPUT);
}

void loop() {
    Serial.print("Sensor 0: ");
    force0 = analogRead(forceSensor0);
    Serial.print(force0);
    
    Serial.print(" Sensor 1: ");
    force1 = analogRead(forceSensor1);
    Serial.print(force1);

    Serial.print(" Sensor 2: ");
    force2 = analogRead(forceSensor2);
    Serial.print(force2);
    
    Serial.print(" Sensor 3: ");
    force3 = analogRead(forceSensor3);
    Serial.print(force3);
    
    Serial.print(" Sum: ");
    sumForces = force0 + force1 + force2 + force3;
    Serial.println(sumForces);
    
    delay(40);
}
