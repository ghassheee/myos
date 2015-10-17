
#include <stdio.h>
#include <string.h>


#define READNUM 1024
FILE *fpr,*fpw;
char *input,*output,*addsrc;
int len,from,to;
char buf[1024];



void usage(){printf("\
 *********\n\
 * usage *\n\
 *********\n\
 \n\
******************************************\n\
$ edimg -i input \n\
        -o output \n\
        --addsrc src\n\ 
              startpoint-of-input\n\ 
              startpoint-of-srcfile\n\ 
              length\n\
******************************************\n");exit(1);
}




void configure_args(int argc, char** argv)
{
    if(argc==1) usage();
    int i=1;
    while(i<argc)
    {
        if (argv[i][0]=='-')
            switch(argv[i][1])
            {
                case 'i': 
                    input=argv[i+1];
                    i+=2;break;
                case 'o':
                    output=argv[i+1];
                    i+=2;break;
                case '-':
                    if (strcmp(&argv[i][2],"addsrc")!=0) usage();
                    addsrc=argv[i+1];
                    from=atoi(argv[i+2]);
                    to=atoi(argv[i+3]);
                    len=atoi(argv[i+4]);
                    i+=5;;break;
                default:
                    usage();
            }
        else usage();
    }
}



void copyonestep(FILE *fpr, FILE *fpw, int bufnum)
{
    int r = fread(buf,1,bufnum,fpr);
    int w = fwrite(buf,1,r,fpw);
    if(r!=READNUM)
        printf("Skipped some %d bytes.\n",READNUM - r);
}


void readonestep(FILE *fpr, int bufnum)
{
    int r = fread(buf,1,bufnum,fpr);
    if(r!=READNUM)
        printf("Skipped some %d bytes.\n",READNUM - r);
}


void copy(char *read,long start, long end)
{
    FILE *fpr = fopen(read, "rb");
    FILE *fpw = fopen(output, "ab");
    
    if (end-EOF==0)
    {
        int i=start/READNUM;
        int rest=start%READNUM;
        while(i>0)
        {
            readonestep(fpr,READNUM);
            --i;
        }
        readonestep(fpr,rest);
        while(1){
            copyonestep(fpr,fpw,READNUM);
            if (feof(fpr)) break;
        }
    }
    else
    {
        int i=(end-start)/READNUM;
        int rest=(end-start)%READNUM;
        while(i>0)
        {   
            copyonestep(fpr,fpw,READNUM);
            --i;
        }
        copyonestep(fpr,fpw,rest);
    }

    fclose(fpr);
    fclose(fpw);
}





    



int main(int argc, char** argv)
{
    configure_args(argc, argv);
    fpw = fopen(output,"w");
    fclose(fpw);
    copy(input,0,from);
    copy(addsrc,from,from+len);
    copy(input,from+len,EOF);
    
    return 0;
}



