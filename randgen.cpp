#include "randgen.h"

RandGen::RandGen()
{

}
int RandGen::giveRandInt(const int from,const int to) const{
    return rand()%(to-from+1)+from;
}
double RandGen::giveRandDouble(const int from,const int to)const{
    return static_cast<double>(giveRandInt(from,to))-giveRandInt(0,1000)/1000.;
}
double RandGen::giveRandDoubleN(const int from,const int to)const{
    int number=static_cast<int>(pow(10,giveRandInt(1,5)));
    return static_cast<double>(giveRandInt(from,to))-static_cast<double>(giveRandInt(0,number)/static_cast<double>(number));
}
