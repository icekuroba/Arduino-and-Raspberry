#include <Servo.h> //libreria de servo
#include <NewPing.h>// Incluye la librería para el sensor ultrasónico
Servo servo1; //
Servo servo2; //
Servo servo3; //
Servo servo4; //
Servo servo5; //
Servo servo6; //
Servo servo7; //
Servo servo8; //
Servo servo9; //
Servo servo10; //
Servo servo11; //

#define TRIGGER_PIN  12
#define ECHO_PIN     13
#define MAX_DISTANCE 20 // Define la distancia máxima para considerar un obstáculo (en centímetros)

int t = 500;
int t2 = 50;
int estado = 0;

// Inicializa el objeto NewPing
NewPing sonar(TRIGGER_PIN, ECHO_PIN, MAX_DISTANCE);

void setup()
{
Serial.begin(9600);
servo1.attach(2); // 
servo2.attach(3); //
servo3.attach(4); //
servo4.attach(5); //
servo5.attach(6); //
servo6.attach(7); //
servo7.attach(8); //
servo8.attach(9); //
servo9.attach(10); //
servo10.attach(11); //
//servo11.attach(11); //

//Las posiciones iniciales
//* Pata posterior 1 *//
 servo1.write(60); // 170 - 138 - 90
 servo2.write(40); // 12 - 32 - 92
 //* Pata posterior 2 *//
 servo3.write(125); // 40- 137 - 114
 servo4.write(137); // 40 - 90 - 130
 //* Pata delantera 3 *//
 servo5.write(120); //60 - 113 - 130
 servo6.write(135); //100 - 60 - 20
 //* Pata delantera 4 *//
 servo7.write(145); //70 - 106 - 143
 servo8.write(115); //146 - 110 - 40
 //** Cabeza *//
 servo9.write(77); //146 - 110 - 40
 servo10.write(87); //146 - 110 - 40 
 //**  Cola */
servo11.write(77); //146 - 110 - 40 

delay(1000);
}

void loop()
{
      //Delante1();
      //Posinicial();
      //girarCabeza();
      //Agachar();
      AgacharAtras();
      //MoverCola();
   int distance = sonar.ping_cm();
          // Comprueba si hay un obstáculo dentro del rango
  if (distance < MAX_DISTANCE) {
    // Si hay un obstáculo, detiene el robot
    detener();
  } else {
    // Si no hay obstáculo, avanza
    Delante1();
  }
}

void Delante1()
{
  //*   izq *//
  servo9.write(40);  //horizontal
  servo10.write(80);  //horizontal
  delay(5);
  
  //* Pata delantera 3 *//
  servo5.write(170);  //
  delay(t2);
  servo6.write(50);  //
  delay(t2);
  servo5.write(80);  //
  delay(t2);
  //* Pata delantera 4 *//
  servo7.write(150);  //
  delay(t2);
  servo8.write(85);  //
  delay(t2);
  //* Pata posterior 2 *//
  servo4.write(157);  //
  delay(t2);
  servo3.write(115);  //
  delay(t2);
  //* Pata posterior 1 *//
  servo2.write(50);  //femor
  delay(t2);
  servo1.write(45);  //rodilla
  delay(150);
  //* der *//
  servo9.write(120);  //horizontal
  delay(5);
  
  //* Pata delantera 4 *//
  servo7.write(80);  //
  delay(t2);
  servo8.write(180);  //
  delay(t2);
  servo7.write(180);  //
  delay(t2);
  //* Pata delantera 3 *//
  servo5.write(130);  //
  delay(t2);
  servo6.write(170);  //
  delay(t2);
  //* Pata posterior 2 *//
  servo3.write(125);  //
  delay(t2);
  servo4.write(117);  //
  delay(t2);
  //* Pata posterior 1 *//
  servo1.write(55);  //femor
  delay(t2);
  servo2.write(10);  //rodilla
  delay(150);
  // Obtiene la distancia medida por el sensor ultrasónico
  int distancia = sonar.ping_cm();
}

void Posinicial()
{
 //* Pata posterior 1 *//
 servo1.write(60); // 170 - 138 - 90
 servo2.write(40); // 12 - 32 - 92
 //* Pata posterior 2 *//
 servo3.write(125); // 40- 137 - 114
 servo4.write(137); // 40 - 90 - 130
 //* Pata delantera 3 *//
 servo5.write(120); //60 - 113 - 130
 servo6.write(135); //100 - 60 - 20
 //* Pata delantera 4 *//
 servo7.write(145); //70 - 106 - 143
 servo8.write(115); //146 - 110 - 40
 //** Cabeza *//
 servo9.write(77); //146 - 110 - 40
 servo10.write(87); //146 - 110 - 40 
}

void detener() {
 //* Pata posterior 1 *//
 servo1.write(60); // 170 - 138 - 90
 servo2.write(40); // 12 - 32 - 92
 //* Pata posterior 2 *//
 servo3.write(125); // 40- 137 - 114
 servo4.write(137); // 40 - 90 - 130
 //* Pata delantera 3 *//
 servo5.write(120); //60 - 113 - 130
 servo6.write(135); //100 - 60 - 20
 //* Pata delantera 4 *//
 servo7.write(145); //70 - 106 - 143
 servo8.write(115); //146 - 110 - 40
 //** Cabeza *//
 servo9.write(77); //146 - 110 - 40
 servo10.write(87); //146 - 110 - 40 
}

void Agachar()
{
 for (int x = 0; x <= 50; x++)
 { 
  //** Cabeza *//
  servo9.write(77 - x); //146 - 110 - 40
  servo10.write(97 - x); //146 - 110 - 40 

  //* Pata posterior 1 *//
  servo1.write(65 - x); // r
  //* Pata posterior 2 *// 
  servo3.write(125 + x); // 40- 137 - 114
  //* Pata delantera 3 *//
  servo5.write(120 + x); // 60 - 113 - 130
  //* Pata delantera 4 *//
  servo7.write(145 - x); // 70 - 106 - 143
  delay(15);
 }
 for (int x = 0; x <= 50; x++)
 {
  //** Cabeza *//
  //servo9.write(27 + x); //146 - 110 - 40
  servo10.write(47 + x); //146 - 110 - 40 

  //* Pata posterior 1 *//
  servo1.write(15 + x); // r
  //* Pata posterior 2 *// 
  servo3.write(175 - x); // 40- 137 - 114
  //* Pata delantera 3 *//
  servo5.write(170 - x); // 60 - 113 - 130
  //* Pata delantera 4 *//
  servo7.write(95 + x); // 70 - 106 - 143
  delay(15);
  }
}

void AgacharAtras()
{
 for (int x = 0; x <= 60; x++)
 {
  //** Cabeza *//
  servo9.write(77 - x); //146 - 110 - 40
  servo10.write(97 + x); //146 - 110 - 40 

  //* Pata posterior 1 *//
  servo1.write(65 - x); // r
  //* Pata posterior 2 *// 
  servo3.write(125 + x); // 40- 137 - 114
  //* Pata delantera 3 *//
  servo5.write(130 - x); // 60 - 113 - 130
  //* Pata delantera 4 *//
  servo7.write(145 + x); // 70 - 106 - 143
  delay(15);
  }
  //** Cabeza *//
  for (int x = 30; x >= 0; x--)
 {
  servo9.write(x);   //horizontal
  delay(5);
 }
 for (int x = 30; x <= 150; x++)
 {
  servo9.write(x);   //horizontal
  delay(5);
 }
 for (int x = 150; x >= 77; x--)
 {
  servo9.write(x);   //horizontal
  delay(5);
  //********//
 }
 delay(300);
 for (int x = 0; x <= 60; x++)
 {
  //   servo9.writw(27+x);   //146 - 110 - 40
  //   servo10.writw(47+x);   //146 - 110 - 40
  //* Pata posterior 1 *//
  servo1.write(15 + x); // r
  //* Pata posterior 2 *// 
  servo3.write(190 - x); // 40- 137 - 114
  //* Pata delantera 3 *//
  servo5.write(65 + x); // 60 - 113 - 130
  //* Pata delantera 4 *//
  servo7.write(205 - x); // 70 - 106 - 143
  delay(15);
 }
}
