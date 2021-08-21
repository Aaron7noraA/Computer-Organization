#include <stdio.h>

int main(void){
    int n,k;
    int sum = 1;
    printf("Please input integer n: ");
    scanf("%d",&n);
    printf("Please input integer k: ");
    scanf("%d",&k);

    for(int i = 0; i < k; i++){
        sum *= (n-i);
    }
    printf("The result is: %d\n",sum);
}