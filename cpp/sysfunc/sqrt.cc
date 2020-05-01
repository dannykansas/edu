#include <iostream>
#include <stdio.h>

double square(double x)         //square a double precision float
{
    return x*x;
}

void print_square(double x)     //print to stdout the square, return nothing
{
    std::cout << "the square of " << x << " is " << square(x) << "\n";
}

void some_func()
{
    double d1 = 2.2;            //initialize a float
    double d2 = 2.4;            //initialize a float with braces
    int i = 7;                  //initialize an int
    d1 = d1+1;                  //assign a sum to d (the float from above)
    i = d1*i;                   //assign a product to i
}

int main()
{
    print_square(1.234);
    print_square(5.555);
}
