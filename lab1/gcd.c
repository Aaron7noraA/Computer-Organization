#include <stdio.h>

int gcd();

int main(void){
    int x,y;
    printf("Please enter integer x: ");
    scanf("%d",&x);
    printf("Please enter integer y: ");
    scanf("%d",&y);

    printf("The result is: %d\n",gcd(x,y));
}

int gcd(int a, int b) {
   if (b == 0)
   return a;
   return gcd(b, a % b);
}
