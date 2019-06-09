#include <stdio.h>
#include <stdlib.h>
#include <SDL2/SDL.h>

#ifdef __cplusplus
extern "C" {
#endif
 void func(unsigned char* line, int pixelQuantity, int operation, double contrast); //contrast=<-255,255>; operation: 0=histogram, 1=kontrast
#ifdef __cplusplus
}
#endif

const int WIDTH = 150, HEIGHT = 150;
int newContrast = 10;
const int maxContrast = 255;
const int minContrast = -255;
const double dzielnikKontrastu = 75.0;
size_t fileSize; //rozmiar pliku obrazka: 138B header + 4*pixelQuantity B danych o pixelach
char *fileData = NULL; //tutaj trzymam oryginalny obrazek
char *tmpFileData = NULL;
unsigned int pixelQuantity=0;

void LoadBmp(const char *fileName){
	if (fileData != NULL){
		free(fileData);
		fileData = NULL;
	}

	FILE *file = fopen(fileName, "rb");
	if (file){
		fseek(file, 0, SEEK_END);
		fileSize = ftell(file);
		fseek(file, 0, SEEK_SET);
		fileData = malloc(sizeof(char) * fileSize);
		fread(fileData, sizeof(char), fileSize, file);

        tmpFileData = malloc(sizeof(char) * fileSize);
	}
	else printf("Error opening the file\n");
	fclose(file);
    pixelQuantity = (fileSize-138)/4;
    printf("File size: %ld, pixels quantity: %ld\n", fileSize, (fileSize-138)/4);
}

void refactor(int operation, int contrast){
    //copyMyFile(); //jesli chcemy wykonywac operacje caly czas z tego samego obrazku to wykomentowac, jesli chcemy wykoywac operacje z orginaly to zostawic
    unsigned char* imgData = tmpFileData+138;
    /*unsigned char red, green, blue, alpha;
    for(int i=0; i<pixelQuantity; ++i){
        // blue = (short) *imgData;
        // blue &= 0xff;
        // green = (short) *(imgData+1);
        // green &= 0xff;
        // red = (short) *(imgData+2);
        // red &= 0xff;
        // alpha = (short) *(imgData+3);
        // alpha &= 0xff;
        // printf("%d: b%hi g%hi r%hi a%hi\n", i, blue, green, red, alpha );

        blue = *imgData;
        green =  *(imgData+1);
        red =  *(imgData+2);
        *imgData = (blue+10)%255;
        *(imgData+1) = (green+10)%255;
        *(imgData+2) = (red+10)%255;
        imgData+=4;
    }*/

    //func(imgData, pixelQuantity, operation, (double)(contrast)/10.0);
    funcInsteadAsm(imgData, pixelQuantity, operation, (double)(contrast)/dzielnikKontrastu);
    
    //if(operation==1) kontrast((double)(contrast)/dzielnikKontrastu);
    //else histogram();
}
void copyMyFile(){
    for(int i=0; i<fileSize; ++i){
        *(tmpFileData+i) = *(fileData+i);
    }
}

int main( int argc, char *argv[] ) {
    LoadBmp("g.bmp"); //////////////////////////////////////////////          FILE NAME
    copyMyFile();
    SDL_Surface *imageSurface = NULL;
    SDL_Surface *windowSurface = NULL;

    if ( SDL_Init( SDL_INIT_EVERYTHING ) < 0 ) {
	    printf("ERROR\n");
    }

    SDL_Window *window = SDL_CreateWindow( "ARKO", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, WIDTH, HEIGHT, SDL_WINDOW_ALLOW_HIGHDPI );
    windowSurface = SDL_GetWindowSurface( window );

    if ( NULL == window ) {
	    printf("ERROR\n");
        return EXIT_FAILURE;
    }

    SDL_Event windowEvent;

	SDL_RWops *data = SDL_RWFromMem(fileData, fileSize);
    imageSurface = SDL_LoadBMP_RW(data, 0);

    if( imageSurface == NULL ) {
	    printf("ERROR\n");
    }

    int workingProgram=1;
    while ( workingProgram )
    {
        if ( SDL_PollEvent( &windowEvent ) ) {
            if (SDL_KEYDOWN == windowEvent.type) {
                switch (windowEvent.key.keysym.sym) {
                    case SDLK_LEFT:  
                        copyMyFile();
                        newContrast = --newContrast < minContrast ? minContrast : newContrast; 
                        printf("Contrast: %f\n", newContrast/dzielnikKontrastu);
                        refactor(1,newContrast);
                        break;
                    case SDLK_RIGHT: 
                        copyMyFile();
                        newContrast = ++newContrast > maxContrast ? maxContrast : newContrast; 
                        printf("Contrast: %f\n", newContrast/dzielnikKontrastu);
                        refactor(1,newContrast);
                        break;
                    case SDLK_UP: //rozciagniecie histogramu
                        copyMyFile(); //przywrocenie z oryginalu
                        refactor(0, 0);
                        newContrast=0;
                        printf("Rozciaganie histogramu\n");
                        break;
                    case SDLK_DOWN: //przywrocenie oryginalu
                        copyMyFile();
                        newContrast=0;
                        printf("Original pic\n");
                        break;
                    case SDLK_ESCAPE: workingProgram=0; break;
                }
                //refactor(0,0);

                SDL_FillRect(windowSurface, NULL, 0x000000);

                SDL_RWops *data = SDL_RWFromMem(tmpFileData, fileSize);
                imageSurface = SDL_LoadBMP_RW(data, 0);
            }
            else if ( SDL_QUIT == windowEvent.type ) {
                break;
            }
        }

        SDL_BlitSurface( imageSurface, NULL, windowSurface, NULL );

        SDL_UpdateWindowSurface( window );
    }

    SDL_FreeSurface( imageSurface );
    SDL_FreeSurface( windowSurface );

    imageSurface = NULL;
    windowSurface = NULL;

    SDL_DestroyWindow( window );
    SDL_Quit( );

    return EXIT_SUCCESS;
}

void kontrast(double contParam){
    unsigned char lut[256];
    double val;
    for(int i=0; i<256; ++i){
        val = contParam*((double)i-127.5) +127.5;
        if(val<=0.0) lut[i]=0;
        else if(val>=255.0) lut[i]=255;
        else lut[i] = (unsigned char) val;
    }
    unsigned char * ptr = tmpFileData+138;
    for(int i=0; i<pixelQuantity; i++){
        *ptr = lut[*ptr];
        *(ptr+1) = lut[*(ptr+1)];
        *(ptr+2) = lut[*(ptr+2)];
        
        ptr += 4;
    }
}
void histogram(){
    unsigned char lutR[256];
    unsigned char lutG[256];
    unsigned char lutB[256];
    unsigned char minR, maxR, minG, maxG, minB, maxB;
    minR=255; maxR=0; minG=255; maxG=0; minB=255; maxB=0;
    unsigned char *ptr = tmpFileData+138;
    for(int i=0; i<pixelQuantity; ++i){ //find min, max
        minB = *ptr<minB ? *ptr : minB;
        maxB = *ptr>maxB ? *ptr : maxB;
        ptr++;
        minG = *ptr<minG ? *ptr : minG;
        maxG = *ptr>maxG ? *ptr : maxG;
        ptr++;
        minR = *ptr<minR ? *ptr : minR;
        maxR = *ptr>maxR ? *ptr : maxR;
        ptr +=2;
    }
    for(int i=0; i<256; i++){
        /*double R = (255.0/(maxR-minR))*(i-minR);
        double G = (255.0/(maxG-minG))*(i-minG);
        double B = (255.0/(maxB-minB))*(i-minB);
        lutR[i] = R>255?255:(unsigned char)R;
        lutG[i] = G>255?255:(unsigned char)G;
        lutB[i] = B>255?255:(unsigned char)B;*/
        lutR[i] = (255.0/(maxR-minR))*(i-minR);
        lutG[i] = (255.0/(maxG-minG))*(i-minG);
        lutB[i] = (255.0/(maxB-minB))*(i-minB);
        //printf("R%d\tG%d\tB%d\n", lutR[i], lutG[i], lutB[i]);
    }
    ptr = tmpFileData+138;
    for(int i=0; i<pixelQuantity; ++i){
        *ptr = lutB[*ptr];
        *(ptr+1) = lutG[*(ptr+1)];
        *(ptr+2) = lutR[*(ptr+2)];
        
        ptr += 4;
    }
}

void funcInsteadAsm(unsigned char* line, int pixelQuantity, int operation, double contrast){
    unsigned char lutR[256];
    unsigned char lutG[256];
    unsigned char lutB[256];
    unsigned char minR, maxR, minG, maxG, minB, maxB;
    unsigned char lut[256];
    double val;
    unsigned char *ptr;

    if(operation == 1){ //kontrast
        for(int i=0; i<256; ++i){
            val = contrast*((double)i-127.5) +127.5;
            if(val<=0.0) lut[i]=0;
            else if(val>=255.0) lut[i]=255;
            else lut[i] = (unsigned char) val;
        }
        ptr = line;
        for(int i=0; i<pixelQuantity; i++){
            *ptr = lut[*ptr];
            *(ptr+1) = lut[*(ptr+1)];
            *(ptr+2) = lut[*(ptr+2)];
            ptr += 4;
        }
    }else { //histogram
        ptr = line;
        for(int i=0; i<pixelQuantity; ++i){ //find min, max
            minB = *ptr<minB ? *ptr : minB;
            maxB = *ptr>maxB ? *ptr : maxB;
            ptr++;
            minG = *ptr<minG ? *ptr : minG;
            maxG = *ptr>maxG ? *ptr : maxG;
            ptr++;
            minR = *ptr<minR ? *ptr : minR;
            maxR = *ptr>maxR ? *ptr : maxR;
            ptr +=2;
        }
        for(int i=0; i<256; i++){
            lutR[i] = (255.0/(maxR-minR))*(i-minR);
            lutG[i] = (255.0/(maxG-minG))*(i-minG);
            lutB[i] = (255.0/(maxB-minB))*(i-minB);
            //printf("R%d\tG%d\tB%d\n", lutR[i], lutG[i], lutB[i]);
        }
        ptr = line;
        for(int i=0; i<pixelQuantity; ++i){
            *ptr = lutB[*ptr];
            *(ptr+1) = lutG[*(ptr+1)];
            *(ptr+2) = lutR[*(ptr+2)];
            ptr += 4;
        }
    }
}