#include<stdio.h>
#include<stdlib.h>
#include<time.h>
void setrnd(){
  srand(time(NULL));
}

unsigned long get_random(){  
  return ((rand() % 3) - 1);
}

unsigned long random_color(){  
  return (rand() % 8);
}