#include <stdio.h>

int htox();
void printbyte();

int main(int argc, char** argv)
{
    int c,i;
    i=0;

    while((c = getchar())!= EOF)
    {
        if (i==0) putchar('\n');
        printbyte(c);
        putchar(' ');
        i=(++i)%16;
    }

    putchar('\n');
    return 0;
}


void printbyte(int a)
{
    char s[3];
    s[0] = htox(a/16);
    s[1] = htox(a%16);
    s[2] = '\0';
    printf("%s",s);
}


int htox(int b)
{
    if ( b<0 || 15<b ) return -1;
    else if ( b < 10 ) return b + '0';
    else return b - 10 + 'a';
    return -1;
}


